// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_print, use_super_parameters

import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/pages/custom_dashboard.dart';
import 'package:do_an_app/pages/map_libre_page.dart';
import 'package:do_an_app/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controllers/mqtt_controller/mqtt_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken().then((value) {
    print("Get token value: $value");
  });
  // If Application is in Background, then it will work.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    handleInitialMessage(message);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);

  // Cấu hình Local Notification
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Xử lý khi nhấn vào Local Notification (foreground)
      if (response.payload != null) {
        handleNotificationClick(response.payload!);
      }
    },
  );

  // Lắng nghe thông báo khi ứng dụng đang mở (foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground Notification: ${message.notification?.title}");

    // Hiển thị thông báo cục bộ
    _showLocalNotification(message);
  });


  runApp(const MyApp());
}

/// Xử lý khi nhấn vào thông báo
void handleNotificationClick(String cowId) {
  final context = navigatorKey.currentState?.context;
  if (context != null) {
    context.read<CowBloc>().add(GetCowByIdEvent(cowId));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapLibrePage()),
    );
  }
}


void handleInitialMessage(RemoteMessage? message) {
  if (message != null) {
    final context = navigatorKey.currentState!.context;
    String messageBody = message.notification?.body ?? '';
    final cowIdPattern = RegExp(r'Cow with ID (\w+) has exited the safe zone');
    final match = cowIdPattern.firstMatch(messageBody);
    String? cowId = match?.group(1);

    if (cowId != null) {
      context.read<CowBloc>().add(GetCowByIdEvent(cowId));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapLibrePage()),
      );
    }
  }
}

/// Hiển thị thông báo cục bộ khi ở foreground
Future<void> _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'default_channel', // ID của kênh thông báo
    'Default Notifications', // Tên của kênh
    channelDescription: 'Channel for foreground notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // ID thông báo
    message.notification?.title ?? 'No Title', // Tiêu đề thông báo
    message.notification?.body ?? 'No Body', // Nội dung thông báo
    platformChannelSpecifics,
    payload: message.data['cowId'], // Truyền cowId qua payload
  );
}

Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("_firebaseMessageBackgroundHandler: $message");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CowBloc>(
          create: (context) => CowBloc(),
        ),
        BlocProvider<SaveZoneBloc>(
          create: (context) => SaveZoneBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
      ],
      child: AppWithMQTT(),
    );
  }
}

class AppWithMQTT extends StatelessWidget {
  AppWithMQTT({Key? key})
      : // Initialize MQTT
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve CowBloc from the context
    final cowBloc = context.read<CowBloc>();

    // Pass CowBloc to MQTTClientHelper
    mqttClientHelper.initialize(cowBloc);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: SplashScreen(
        cowBloc: context.read<CowBloc>(),
        saveZoneBloc: context.read<SaveZoneBloc>(),
      ), // Start with the SplashScreen
      routes: {
        '/home': (context) =>
            Scaffold(body: SafeArea(child: CustomDashboard())),
        '/map': (context) => MapLibrePage(),
      },
    );
  }
}

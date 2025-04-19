import 'dart:async';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:do_an_app/screens/cow_location_screen/cow_location_screen.dart';
import 'package:do_an_app/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  final CowBloc cowBloc;
  final SaveZoneBloc saveZoneBloc;

  const SplashScreen({super.key, required this.cowBloc, required this.saveZoneBloc});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialMessage();
  }

  Future<void> _checkInitialMessage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      loadSplashToMapLibre(initialMessage);
    } else {
      loadSplashToHome();
    }
  }

  Future<Timer> loadSplashToHome() async {
    return Timer(
      const Duration(seconds: 2),
      _navigateToHomePage,
    );
  }

  Future<Timer> loadSplashToMapLibre(RemoteMessage? initialMessage) async {
    return Timer(
      const Duration(seconds: 2),
      () {
        _handleNavigationFromMessage(initialMessage!);
      },
    );
  }

  void _handleNavigationFromMessage(RemoteMessage message) {
    final messageBody = message.notification?.body ?? '';
    final cowIdPattern = RegExp(r'Cow with ID (\w+) has exited the safe zone');
    final match = cowIdPattern.firstMatch(messageBody);
    final cowId = match?.group(1);
    if (cowId != null) {
      widget.saveZoneBloc.add(GetAllSaveZoneEvent());
      widget.cowBloc.add(GetCowByIdEvent(cowId));
      _navigateWithFade(CowLocationScreen());
    } else {
      _navigateToHomePage();
    }
  }
  void _navigateToHomePage() {
    _navigateWithFade(const Scaffold(body: SafeArea(child: LoginScreen())));
  }
  void _navigateWithFade(Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeTransition =
              FadeTransition(opacity: animation, child: child);
          final slideTransition = SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1), // Bắt đầu từ dưới màn hình
              end: Offset.zero,
            ).animate(animation),
            child: fadeTransition,
          );
          return slideTransition;
        },
        transitionDuration: Duration(milliseconds: 2000), // Giảm xuống nếu cần
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.shade200,
        child: Center(
          child: Lottie.asset(
            "assets/animations/splash_animation.json",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

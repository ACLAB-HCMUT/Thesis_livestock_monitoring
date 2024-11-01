import 'package:do_an_app/test_cow.dart';

import 'package:flutter/material.dart';
// import 'controllers/mqtt_controller/mqtt_bloc.dart';

void main() {
  // mqttClientHelper.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: SafeArea(
          child: TestCowPage())
      )
      
    );
  }
}



import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea( 
      child: Scaffold(
        body: const Text("setting page"),
        appBar: AppBar(title: const Text("setting page")),
    ));
  }
}
import 'package:flutter/material.dart';

class WarningPage extends StatelessWidget {
  const WarningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea( 
      child: Scaffold(
        body: const Text("warning page"),
        appBar: AppBar(title: const Text("warning page")),
      )
    );
  }
}
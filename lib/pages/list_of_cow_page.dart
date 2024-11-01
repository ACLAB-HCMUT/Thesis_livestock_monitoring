import 'package:flutter/material.dart';

class ListOfCowPage extends StatelessWidget {
  const ListOfCowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Text("list of cow page"),
        appBar: AppBar(title: const Text("list of cow page")),
      )
    );
  }
}

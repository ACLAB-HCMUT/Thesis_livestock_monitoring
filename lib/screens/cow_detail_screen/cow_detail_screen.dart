import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/cow_details_card.dart';
import 'widgets/bottom_navigation.dart';

class CowDetailScreen extends StatelessWidget {
  CowDetailScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text(
          "Cow Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          CowDetailsCard(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomDashboardScreen()),
          );
        },
        backgroundColor: Colors.green.shade300,
        child: Icon(Icons.home, size: 28, color: Colors.white),
        shape: const CircleBorder(),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

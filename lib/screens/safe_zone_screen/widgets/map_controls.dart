import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:flutter/material.dart';

class MapControls {
  static FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomDashboardScreen()),
        );
      },
      backgroundColor: Colors.green.shade300,
      child: Icon(Icons.home, size: 28, color: Colors.white),
      shape: CircleBorder(),
    );
  }

  static BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.green.shade300,
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.map, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
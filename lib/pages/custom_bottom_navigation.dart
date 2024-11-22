import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onMapPressed;
  final VoidCallback onSettingsPressed;

  const CustomNavigationBar({
    Key? key,
    required this.onHomePressed,
    required this.onMapPressed,
    required this.onSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BottomAppBar
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomAppBar(
            color: Colors.green.shade300,
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.map, color: Colors.white),
                  onPressed: onMapPressed,
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: onSettingsPressed,
                ),
              ],
            ),
          ),
        ),
        // FloatingActionButton
        Align(
          alignment: Alignment(0, 1), // Vị trí FloatingActionButton
          child: FloatingActionButton(
            onPressed: onHomePressed,
            backgroundColor: Colors.green.shade300,
            child: Icon(Icons.home, size: 28, color: Colors.white),
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }
}

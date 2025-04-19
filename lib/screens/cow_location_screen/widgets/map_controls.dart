import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  final bool showPath;
  final VoidCallback onTogglePath;

  const MapControls({
    required this.showPath,
    required this.onTogglePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(
            Icons.map,
            color: Colors.white,
          ),
          onPressed: onTogglePath,
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
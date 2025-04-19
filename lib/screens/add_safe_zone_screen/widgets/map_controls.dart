import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onDrawPolygon;
  final VoidCallback onClearPoints;

  const MapControls({
    required this.onDrawPolygon,
    required this.onClearPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          left: 20,
          child: FloatingActionButton(
            heroTag: "btn1",
            child: Icon(Icons.done),
            onPressed: onDrawPolygon, // Complete polygon
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            heroTag: "btn2",
            child: Icon(Icons.clear),
            backgroundColor: Colors.red.shade300,
            onPressed: onClearPoints, // Complete polygon
          ),
        ),
      ],
    );
  }
}
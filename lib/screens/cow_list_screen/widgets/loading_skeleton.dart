import 'package:flutter/material.dart';

class LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              SizedBox(height: 8),
              Container(
                height: 15,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
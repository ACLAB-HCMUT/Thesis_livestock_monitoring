import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final String duration;
  final double percentage;
  const LegendItem(this.label, this.color, this.duration, this.percentage,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final percentageStr = (percentage * 100).toStringAsFixed(1);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              '$label ($percentageStr%)',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(duration),
      ],
    );
  }
}

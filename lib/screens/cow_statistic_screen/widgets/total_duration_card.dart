import 'package:flutter/material.dart';

class TotalDurationCard extends StatelessWidget {
  final Map<String, dynamic> analyticsData;

  const TotalDurationCard({
    Key? key,
    required this.analyticsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (analyticsData.isEmpty || analyticsData['data'] == null) {
      return Container();
    }

    final data = analyticsData['data'] as List;

    int totalRunning = 0;
    int totalWalking = 0;
    int totalIdle = 0;

    for (final item in data) {
      totalRunning += (item['runningDuration'] ?? 0) as int;
      totalWalking += (item['walkingDuration'] ?? 0) as int;
      totalIdle += (item['idleDuration'] ?? 0) as int;
    }

    final totalSeconds = totalRunning + totalWalking + totalIdle;
    final runningPercentage = totalSeconds > 0 ? (totalRunning / totalSeconds * 100).toStringAsFixed(1) : '0';
    final walkingPercentage = totalSeconds > 0 ? (totalWalking / totalSeconds * 100).toStringAsFixed(1) : '0';
    final idlePercentage = totalSeconds > 0 ? (totalIdle / totalSeconds * 100).toStringAsFixed(1) : '0';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Duration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DurationItem(
                  label: 'Running',
                  seconds: totalRunning,
                  percentage: runningPercentage,
                  color: Colors.green,
                ),
                _DurationItem(
                  label: 'Walking',
                  seconds: totalWalking,
                  percentage: walkingPercentage,
                  color: Colors.blue,
                ),
                _DurationItem(
                  label: 'Idle',
                  seconds: totalIdle,
                  percentage: idlePercentage,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationItem extends StatelessWidget {
  final String label;
  final int seconds;
  final String percentage;
  final Color color;

  const _DurationItem({
    required this.label,
    required this.seconds,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '$hours h $minutes m',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text('$percentage%'),
      ],
    );
  }
}

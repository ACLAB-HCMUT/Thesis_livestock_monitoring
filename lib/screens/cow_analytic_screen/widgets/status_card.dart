import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/screens/cow_analytic_screen/utils/format_helpers.dart';
import 'package:do_an_app/screens/cow_analytic_screen/utils/status_helpers.dart';
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String? currentStatus;
  final Duration? duration;
  const StatusCard(this.currentStatus, this.duration, {super.key});

  @override
  Widget build(BuildContext context) {
    final statusColors = {
      'running': Colors.green,
      'walking': Colors.blue,
      'idle': Colors.orange,
    };
    final statusKey =currentStatus;
    final color = statusColors[statusKey] ?? Colors.grey;
    final durationText =
        duration != null ? FormatHelpers.formatDuration(duration!) : '00:00:00';

        return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  currentStatus!.toUpperCase() ?? 'UNKNOWN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: $durationText'),
                Icon(
                  StatusHelpers.getStatusIcon(currentStatus),
                  size: 32,
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
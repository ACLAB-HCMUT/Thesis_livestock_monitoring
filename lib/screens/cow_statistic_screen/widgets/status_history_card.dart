import 'package:do_an_app/screens/cow_analytic_screen/utils/format_helpers.dart';
import 'package:do_an_app/screens/cow_analytic_screen/utils/status_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusHistoryCard extends StatelessWidget {
  final List<dynamic> statusHistory;
  const StatusHistoryCard({Key? key, required this.statusHistory})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (statusHistory.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('No status history available')),
        ),
      );
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statusHistory.length.clamp(0, 10), // Show max 10 items
              itemBuilder: (context, index) {
                final item = statusHistory[index];
                final startTime = DateTime.parse(item['startTime']);
                final endTime = item['endTime'] != null
                    ? DateTime.parse(item['endTime'])
                    : null;
                final duration = Duration(seconds: item['duration'] ?? 0);

                final durationText = endTime != null
                    ? FormatHelpers.formatDuration(duration)
                    : 'In progress';
                return ListTile(
                  leading: Icon(
                    StatusHelpers.getStatusIcon(item['status']),
                    color: StatusHelpers.getStatusColor(item['status']),
                  ),
                  title: Text(
                    item['status'].toString().toUpperCase(),
                    style: TextStyle(
                      color: StatusHelpers.getStatusColor(item['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${DateFormat('MM/dd HH:mm').format(startTime)} - $durationText',
                  ),
                  dense: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:do_an_app/screens/cow_analytic_screen/utils/format_helpers.dart';
import 'package:do_an_app/screens/cow_analytic_screen/utils/status_helpers.dart';
import 'package:flutter/material.dart';

import '../utils/status_duration.dart';

class StatusHistoryCard extends StatelessWidget {
  final List<StatusDuration> statusHistory;
  const StatusHistoryCard(this.statusHistory, {super.key});

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 200,
              child: statusHistory.isEmpty
                  ? const Center(child: Text('No status history yet'))
                  : ListView.builder(
                      itemCount: statusHistory.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final statusItem = statusHistory[statusHistory.length - 1 - index];
                        String duration = '...';
                        
                        if (statusItem.endTime != null) {
                          duration = FormatHelpers.formatDuration(statusItem.duration!);
                        }
                        
                        return ListTile(
                          leading: Icon(
                            StatusHelpers.getStatusIcon(statusItem.status),
                            color: StatusHelpers.getStatusColor(statusItem.status),
                          ),
                          title: Text(statusItem.status),
                          subtitle: Text(
                            '${FormatHelpers.formatTime(statusItem.startTime)} | $duration',
                          ),
                          dense: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class StatusHelpers {
  static IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'walking':
        return Icons.directions_walk;
      case 'idle':
        return Icons.hourglass_empty;
      default:
        return Icons.help_outline;
    }
  }
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'running':
        return Colors.green;
      case 'walking':
        return Colors.blue;
      case 'idle':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
class StatusDuration {
  final String status;
  final DateTime startTime;
  DateTime? endTime;
  Duration? duration;
  
  StatusDuration({
    required this.status,
    required this.startTime,
  });
}
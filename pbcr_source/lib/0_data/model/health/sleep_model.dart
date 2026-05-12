class SleepModel {
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  const SleepModel({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  /// 수면 시간을 분으로 반환
  int get sleepMinutes => endTime.difference(startTime).inMinutes;
}

import 'package:icreat_dct/0_data/model/health/sleep_model.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class DailySleepRecord {
  const DailySleepRecord({
    required this.date,
    required this.sleepData,
  });

  final DateTime date;
  final List<SleepModel> sleepData;

  factory DailySleepRecord.empty([DateTime? date]) {
    return DailySleepRecord(
      date: date ?? DateTimeExt.getToday(),
      sleepData: [],
    );
  }

  List<SleepModel> get validSleepData => sleepData.where((element) => element.sleepMinutes > 0).toList();

  int get totalSleepMinutes => validSleepData.fold(
      0, (previousValue, element) => previousValue + element.sleepMinutes);

  String get avgSleepDurationString => '${totalSleepMinutes ~/ 60}시간 ${totalSleepMinutes % 60}분';

  int get sleepHour => totalSleepMinutes ~/ 60;
  int get sleepMin => totalSleepMinutes % 60;

  String format() => '$sleepHour시간 $sleepMin분';
}
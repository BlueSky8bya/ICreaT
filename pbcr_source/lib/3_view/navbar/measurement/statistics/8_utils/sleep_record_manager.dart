import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/health/daily_sleep_record.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class SleepRecordManager {
  final RxMap<DateTime, DailySleepRecord> _sleepRecords = RxMap();

  void addSleepRecord(DailySleepRecord sleepRecord) {
    final localizedDate = sleepRecord.date.toLocalize();
    _sleepRecords[localizedDate] = sleepRecord;
  }

  void addSleepRecords(List<DailySleepRecord> sleepRecords) {
    for (var sleepRecord in sleepRecords) {
      addSleepRecord(sleepRecord);
    }
  }

  DailySleepRecord getSleepRecord(DateTime date) {
    final localizedDate = date.toLocalize();
    return _sleepRecords[localizedDate] ?? DailySleepRecord.empty(date);
  }

  DailySleepRecord getTodaySleepRecord() {
    return getSleepRecord(DateTime.now());
  }

  List<DailySleepRecord> getSleepRecords(DateTime startDate, DateTime endDate) {
    final start = startDate.toLocalize();
    final end = endDate.toLocalize();
      return _sleepRecords.values
        .where((element) => element.date.isBetween(start, end))
        .toList();
  }

  // for Test 전부 가져오기
  List<DailySleepRecord> getAllSleepRecords() {
    return _sleepRecords.values.toList();
  }
}
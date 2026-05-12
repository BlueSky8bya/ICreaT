import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class StepRecordManager {
  final RxMap<DateTime, DailyStepRecord> _stepRecords = RxMap();

  void addStepRecord(DailyStepRecord stepRecord) {
    final localizedDate = stepRecord.date.toLocalize();
    _stepRecords[localizedDate] = stepRecord;
  }

  void addStepRecords(List<DailyStepRecord> stepRecords) {
    for (var stepRecord in stepRecords) {
      addStepRecord(stepRecord);
    }
  }

  DailyStepRecord getStepRecord(DateTime date) {
    final localizedDate = date.toLocalize();
    return _stepRecords[localizedDate] ?? DailyStepRecord.empty(date);
  }

  DailyStepRecord getTodayStepRecord() {
    return getStepRecord(DateTime.now());
  }

  List<DailyStepRecord> getStepRecords(DateTime startDate, DateTime endDate) {
    final start = startDate.toLocalize();
    final end = endDate.toLocalize();
    return _stepRecords.values.where((el) => el.date.isBetween(start, end)).toList();
  }

  // for Test 전부 가져오기
  List<DailyStepRecord> getAllStepRecords() {
    return _stepRecords.values.toList();
  }
}
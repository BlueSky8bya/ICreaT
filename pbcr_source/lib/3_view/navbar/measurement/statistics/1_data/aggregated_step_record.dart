import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class AggregatedStepRecord {
  final List<DailyStepRecord> stepRecords;

  AggregatedStepRecord({
    required this.stepRecords,
  });

  /// 시작 날짜
  DateTime get startDate {
    return stepRecords.first.date;
  }

  /// 종료 날짜
  DateTime get endDate {
    return stepRecords.last.date;
  }

  /// 평균 걸음 수
  int get avgStepCount {
    if (stepRecords.isEmpty) return 0;
    return stepRecords.fold(0, (sum, record) => sum + record.totalStepCount) ~/
        stepRecords.length;
  }

  String get formattedDate {
    if (startDate == endDate) {
      return startDate.toMD();
    }

    if (startDate.isSameMonth(endDate)) {
      return '${startDate.toMD()} ~ ${endDate.day}';
    }

    return '${startDate.toMD()} ~ ${endDate.toMD()}';
  }

  @override
  String toString() {
    return 'AggregatedStepRecord(startDate: $startDate, endDate: $endDate, avgStepCount: $avgStepCount, stepRecords: $stepRecords)';
  }
}
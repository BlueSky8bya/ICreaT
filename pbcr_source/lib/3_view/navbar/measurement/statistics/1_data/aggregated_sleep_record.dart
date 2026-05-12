import 'package:icreat_dct/0_data/model/health/daily_sleep_record.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class AggregatedSleepRecord {
  final List<DailySleepRecord> sleepRecords;

  AggregatedSleepRecord({
    required this.sleepRecords,
  });

  List<DailySleepRecord> get validSleepRecords {
    return sleepRecords.where((record) => record.totalSleepMinutes > 0).toList();
  }

  /// 시작 날짜
  DateTime get startDate {
    return sleepRecords.first.date;
  }

  /// 종료 날짜
  DateTime get endDate {
    return sleepRecords.last.date;
  }

  /// 평균 수면 시간(분)
  int get avgSleepMinutes {
    if (validSleepRecords.isEmpty) return 0;
    return validSleepRecords.fold(0, (sum, record) => sum + record.totalSleepMinutes) ~/
        validSleepRecords.length;
  }

  Duration get avgSleepDuration {
    return Duration(minutes: avgSleepMinutes);
  }

  String get avgSleepDurationString {
    return '${avgSleepDuration.inHours}시간 ${avgSleepDuration.inMinutes % 60}분';
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
    return 'AggregatedSleepRecord(startDate: $startDate, endDate: $endDate, avgSleepMinutes: $avgSleepMinutes, sleepRecords: $sleepRecords)';
  }
}
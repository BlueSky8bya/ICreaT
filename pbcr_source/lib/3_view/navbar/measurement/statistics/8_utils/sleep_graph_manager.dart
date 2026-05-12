import 'dart:math';

import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/health/daily_sleep_record.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/1_data/aggregated_sleep_record.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/8_extension/list_ext.dart';

/// 스텝 레코드 집계

/// 스텝 차트 매니저
class SleepGraphManager {
  final RxList<DateTime> _chartReferenceDates = RxList();

  /// _chartReferenceDates의 인덱스 범위
  List<(int, int)> _chartReferenceIndex = [];

  /// x좌표 index -> 스텝 레코드 리스트
  final RxMap<int, AggregatedSleepRecord> _aggregatedSleepRecords =
      RxMap<int, AggregatedSleepRecord>();

  Map<int, AggregatedSleepRecord> get aggregatedSleepRecords =>
      // ignore: invalid_use_of_protected_member
      _aggregatedSleepRecords.value;

  List<int> get xLabels {
    final xLabels = _aggregatedSleepRecords.keys.toList();
    if (xLabels.length > 7) {
      return xLabels.spaceBetween(7);
    }
    return xLabels;
  }

  int get maxX => _aggregatedSleepRecords.length - 1;

  /// 600 -> 10시간
  final RxInt _maxY = RxInt(600);
  int get maxY => max(_maxY.value, 600);

  // initialize or update step records
  /// index -> _chartReferenceIndex의 인덱스 -> _chartReferenceDates 범위 가져오기 -> 스텝 레코드 가져오기
  final DailySleepRecord Function(DateTime date)? _getSleepRecord;

  SleepGraphManager(this._getSleepRecord);

  ///  x좌표 index -> 스텝 레코드 리스트
  /// refIndex는 setStatisticsPeriod에서 설정한 targetGroups 개수보다 작아야 한다.
  AggregatedSleepRecord makeAggregatedSleepRecords(
    int refIndex,
  ) {
    final indexRange = _chartReferenceIndex[refIndex];
    final startIndex = indexRange.$1;
    final endIndex = indexRange.$2;
    final dates = _chartReferenceDates.sublist(startIndex, endIndex + 1);
    final sleepRecords = dates
        .map((date) =>
            _getSleepRecord?.call(date) ??
            DailySleepRecord(date: date, sleepData: []))
        .toList();
    return AggregatedSleepRecord(sleepRecords: sleepRecords);
  }

  void setStatisticsPeriod(
    DateTime startDate,
    DateTime endDate,
    int targetGroups,
  ) {
    // startDate ~ endDate 날짜 리스트 생성
    _chartReferenceDates.value = _makeDatesByPeriod(startDate, endDate);
    // 날짜 리스트를 targetGroups 개수로 나누어 인덱스 범위 생성
    _chartReferenceIndex =
        _chartReferenceDates.splitIntoEqualRanges(targetGroups);
    // 인덱스 범위 기반으로 스텝 레코드 집계
    memoizeAggregatedSleepRecords(targetGroups);
  }

  void memoizeAggregatedSleepRecords(int targetGroups) {
    _aggregatedSleepRecords.clear();
    int maxSleepMinutes = 0;
    for (var i = 0; i < targetGroups; i++) {
      _aggregatedSleepRecords[i] = makeAggregatedSleepRecords(i);
      maxSleepMinutes = max(
        maxSleepMinutes,
        _aggregatedSleepRecords[i]!.avgSleepMinutes,
      );
    }
    _maxY.value = maxSleepMinutes + 60;
  }

  List<DateTime> _makeDatesByPeriod(
    DateTime startDate,
    DateTime endDate,
  ) {
    final dates = <DateTime>[];
    var currentDate = startDate;

    while (currentDate.isSameOrBefore(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dates;
  }
}

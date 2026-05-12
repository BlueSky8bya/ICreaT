import 'dart:math';

import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/1_data/aggregated_step_record.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/8_extension/list_ext.dart';

/// 스텝 레코드 집계

/// 스텝 차트 매니저
class StepGraphManager {
  final RxList<DateTime> _chartReferenceDates = RxList();

  /// _chartReferenceDates의 인덱스 범위
  List<(int, int)> _chartReferenceIndex = [];

  /// x좌표 index -> 스텝 레코드 리스트
  final RxMap<int, AggregatedStepRecord> _aggregatedStepRecords =
      RxMap<int, AggregatedStepRecord>();

  Map<int, AggregatedStepRecord> get aggregatedStepRecords =>
      // ignore: invalid_use_of_protected_member
      _aggregatedStepRecords.value;

  List<int> get xLabels {
    final xLabels = _aggregatedStepRecords.keys.toList();
    if (xLabels.length > 7) {
      return xLabels.spaceBetween(7);
    }
    return xLabels;
  }

  int get maxX => _aggregatedStepRecords.length - 1;

  final RxInt _maxY = RxInt(10000);
  int get maxY => max(_maxY.value, 10000);

  // initialize or update step records
  /// index -> _chartReferenceIndex의 인덱스 -> _chartReferenceDates 범위 가져오기 -> 스텝 레코드 가져오기
  final DailyStepRecord Function(DateTime date)? _getStepRecord;

  StepGraphManager(this._getStepRecord);

  ///  x좌표 index -> 스텝 레코드 리스트
  /// refIndex는 setStatisticsPeriod에서 설정한 targetGroups 개수보다 작아야 한다.
  AggregatedStepRecord makeAggregatedStepRecords(
    int refIndex,
  ) {
    final indexRange = _chartReferenceIndex[refIndex];
    final startIndex = indexRange.$1;
    final endIndex = indexRange.$2;
    final dates = _chartReferenceDates.sublist(startIndex, endIndex + 1);
    final stepRecords = dates
        .map((date) =>
            _getStepRecord?.call(date) ??
            DailyStepRecord(date: date, stepDataList: []))
        .toList();
    return AggregatedStepRecord(stepRecords: stepRecords);
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
    memoizeAggregatedStepRecords(targetGroups);
  }

  void memoizeAggregatedStepRecords(int targetGroups) {
    _aggregatedStepRecords.clear();
    int maxStepCount = 0;
    for (var i = 0; i < targetGroups; i++) {
      _aggregatedStepRecords[i] = makeAggregatedStepRecords(i);
      maxStepCount = max(maxStepCount, _aggregatedStepRecords[i]!.avgStepCount);
    }
    _maxY.value = maxStepCount + 1000;
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

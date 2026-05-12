import 'dart:async';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/health/daily_sleep_record.dart';
import 'package:icreat_dct/1_service/common/fgbg_service.dart';
import 'package:icreat_dct/1_service/health_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/1_data/stats_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/8_utils/sleep_record_manager.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/8_utils/sleep_graph_manager.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class SleepStatisticsViewModel extends BaseViewModel {
  final FgBgService _fgBgService;
  final HealthService _healthService;

  SleepStatisticsViewModel(this._fgBgService, this._healthService);

  DateTime _lastSaveDate = DateTime.now();

  bool isDateChanged(DateTime date) => _lastSaveDate.isSameDate(date);

  DateTime get oneMonthAgo => DateTime.now().subtract(Duration(days: 30));
  DateTime get threeMonthsAgo => DateTime.now().subtract(Duration(days: 90));
  DateTime get sixMonthsAgo => DateTime.now().subtract(Duration(days: 180));

  // ---
  final Rx<StatsType> _statsType = StatsType.oneWeek.obs;
  StatsType get statsType => _statsType.value;

  // ---

  final SleepRecordManager _sleepRecordManager = SleepRecordManager();

  DailySleepRecord get todaySleepRecord =>
      _sleepRecordManager.getTodaySleepRecord();

  List<DailySleepRecord> getSleepRecords(
          DateTime startDate, DateTime endDate) =>
      _sleepRecordManager.getSleepRecords(startDate, endDate);

  List<DailySleepRecord> get allSleepRecords =>
      _sleepRecordManager.getAllSleepRecords();

  // ---
  late final SleepGraphManager _sleepChartManager =
      SleepGraphManager(_sleepRecordManager.getSleepRecord);

  SleepGraphManager get sleepChartManager => _sleepChartManager;

  @override
  void onInit() async {
    super.onInit();

    initListener();
    await _initSleepRecords();
    handleStatsTypeChanged(statsType);

    completeInit();
  }

  Future<void> _initSleepRecords() async {
    await _fetchSleepRecords(sixMonthsAgo, DateTime.now());
  }

  void initListener() {
    _fgBgService.addListener((type) {
      if (type == FGBGType.foreground) {
        final now = DateTime.now();
        if (isDateChanged(now)) {
          _fetchTodaySleepRecord();
          _lastSaveDate = now;
        }
      }
    });
  }

  void _fetchTodaySleepRecord() {
    _healthService.getTodaySleepRecord().then((value) {
      _sleepRecordManager.addSleepRecord(value);
    });
  }

  Future<void> _fetchSleepRecords(DateTime startDate, DateTime endDate) async {
    await _healthService
        .getSleepRecordsForPeriod(startDate, endDate)
        .then((value) {
      _sleepRecordManager.addSleepRecords(value);
    });
  }

  void handleStatsTypeChanged(StatsType value) {
    _statsType.value = value;
    _sleepChartManager.setStatisticsPeriod(
      DateTimeExt.getToday().subtract(Duration(days: value.days)),
      DateTimeExt.getToday(),
      value.targetGroups,
    );
  }
}

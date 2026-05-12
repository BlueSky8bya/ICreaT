import 'dart:async';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/1_service/common/fgbg_service.dart';
import 'package:icreat_dct/1_service/health_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/1_data/stats_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/8_utils/step_graph_manager.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/8_utils/step_record_manager.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class StepStatisticsViewModel extends BaseViewModel {
  final FgBgService _fgBgService;
  final HealthService _healthService;

  StepStatisticsViewModel(this._fgBgService, this._healthService);

  DateTime _lastSaveDate = DateTime.now();

  bool isDateChanged(DateTime date) => _lastSaveDate.isSameDate(date);

  StreamSubscription<DailyStepRecord>? _stepSubscription;

  DateTime get oneMonthAgo => DateTime.now().subtract(Duration(days: 30));
  DateTime get threeMonthsAgo => DateTime.now().subtract(Duration(days: 90));
  DateTime get sixMonthsAgo => DateTime.now().subtract(Duration(days: 180));


  // ---
  final Rx<StatsType> _statsType = StatsType.oneWeek.obs;
  StatsType get statsType => _statsType.value;

  // ---

  final StepRecordManager _stepRecordManager = StepRecordManager();

  DailyStepRecord get todayStepRecord => _stepRecordManager.getTodayStepRecord();

  List<DailyStepRecord> getStepRecords(DateTime startDate, DateTime endDate) =>
      _stepRecordManager.getStepRecords(startDate, endDate);

  List<DailyStepRecord> get allStepRecords =>
      _stepRecordManager.getAllStepRecords();

  // ---
  late final StepGraphManager _stepChartManager = StepGraphManager(_stepRecordManager.getStepRecord);

  StepGraphManager get stepChartManager => _stepChartManager;

  @override
  void onInit() async{
    super.onInit();

    initListener();
    await _initStepRecords();
    handleStatsTypeChanged(statsType);

    _stepSubscription = _healthService.stepStream.listen((event) {
      _stepRecordManager.addStepRecord(event);
    });

    _connectStepStream();

    completeInit();
  }


  Future<void> _initStepRecords() async {
    await _fetchStepRecords(sixMonthsAgo, DateTime.now());
  }

  void initListener() {
    _fgBgService.addListener((type) {
      if (type == FGBGType.foreground) {
        _reconnectStepStream();

        final now = DateTime.now();
        if (isDateChanged(now)) {
          _fetchTodayStepCount();
          _lastSaveDate = now;
        }
      }
    });
  }

  @override
  void onClose() {
    // 스트림 구독 해제
    _stepSubscription?.cancel();
    _healthService.stopListeningStepCount(); // 추가 필요
    super.onClose();
  }


  void _connectStepStream() {
    _healthService.startListeningStepCount(
        DateTimeExt.getToday(), DateTime.now());
  }

  void _reconnectStepStream() {
    _healthService.stopListeningStepCount();
    _connectStepStream();
  }

  void _fetchTodayStepCount() {
    _healthService.getTodayStepRecord().then((value) {
      _stepRecordManager.addStepRecord(value);
    });
  }

  Future<void> _fetchStepRecords(DateTime startDate, DateTime endDate) async {
    await _healthService.getStepRecordsForPeriod(startDate, endDate).then((value) {
      _stepRecordManager.addStepRecords(value);
    });
  }

  void handleStatsTypeChanged(StatsType value) {
    _statsType.value = value;
    _stepChartManager.setStatisticsPeriod(
      DateTimeExt.getToday().subtract(Duration(days: value.days)),
      DateTimeExt.getToday(),
      value.targetGroups,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/health/daily_sleep_record.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/1_service/common/fgbg_service.dart';
import 'package:icreat_dct/1_service/health_service.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class MeasurementViewModel extends BaseViewModel {
  final FgBgService _fgBgService;
  final HealthService _healthService;

  MeasurementViewModel(
    this._fgBgService,
    this._healthService,
  );

  DateTime _lastSaveDate = DateTime.now();

  bool isDateChanged(DateTime date) {
    return _lastSaveDate.isSameDate(date);
  }

  // PHR
  final Rx<DailyStepRecord> _todayStepRecord = Rx(DailyStepRecord.empty());
  DailyStepRecord get todayStepRecord => _todayStepRecord.value;

  final Rx<DailySleepRecord> _todaySleepRecord = Rx(DailySleepRecord.empty());
  DailySleepRecord get todaySleepRecord => _todaySleepRecord.value;

  StreamSubscription<DailyStepRecord>? _stepSubscription;

  // State

  final Rx<DateTime> _currentDate = Rx(DateTimeExt.getToday());
  DateTime get currentDate => _currentDate.value;

  @override
  void onInit() async {
    super.onInit();

    if (DeviceInfo.isIOS && !_healthService.checkAppleHealthRequested()) {
      _healthService.addAppleHealthRequestedListener(() {
        Logger.debug('Apple Health Requested');
        _initialize();
      });
      return;
    }

    _initialize();
  }

  void _initialize() {
    initListener();
    fetchTodayStepCount();
    fetchTodaySleepRecord();
    // 스트림 구독 시작
    _stepSubscription = _healthService.stepStream.listen((event) {
      _todayStepRecord.value = event;
    });

    _healthService.startListeningStepCount(
        DateTimeExt.getToday(), DateTime.now());
    completeInit();
  }

  void initListener() {
    _fgBgService.addListener((type) {
      if (type == FGBGType.foreground) {
        _reconnectStepStream();

        final now = DateTime.now();
        if (isDateChanged(now)) {
          fetchTodayStepCount();
          fetchTodaySleepRecord();
          _lastSaveDate = now;
          _currentDate.value = now;
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

  void fetchTodayStepCount() {
    _healthService.getTodayStepRecord().then((value) {
      _todayStepRecord.value = value;
    });
  }

  void fetchTodaySleepRecord() {
    _healthService.getTodaySleepRecord().then((value) {
      _todaySleepRecord.value = value;
    });
  }

  void _reconnectStepStream() {
    _healthService.stopListeningStepCount();
    _healthService.startListeningStepCount(
        DateTimeExt.getToday(), DateTime.now());
  }

  // 네비게이션
  void onTapMeasureType(BuildContext context, MeasurementType measurementType) {
    CommonNavigator.toMeasurementSelect(
      context,
      measurementType: measurementType,
    );
  }

  void handleTapStepStatistics(BuildContext context) {
    CommonNavigator.toStepStatistics(context);
  }

  void handleTapSleepStatistics(BuildContext context) {
    CommonNavigator.toSleepStatistics(context);
  }
}

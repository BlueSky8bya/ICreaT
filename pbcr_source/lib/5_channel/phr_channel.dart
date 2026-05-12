import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/0_data/model/health/phr_sleep_model.dart';
import 'package:icreat_dct/0_data/model/health/phr_step_model.dart';
import 'package:icreat_dct/0_data/model/health/sleep_model.dart';
import 'package:icreat_dct/0_data/model/health/step_model.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/8_extension/int_ext.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';

class PhrChannel {
  PhrChannel() {
    _channel = const MethodChannel('io.lokks.careease/phr');
    _channel?.setMethodCallHandler(_handleMethod);
  }

  MethodChannel? _channel;

  /// Android Only
  static const _methodGetNeedPostStepList = 'getNeedPostStepList';
  static const _methodUpdatePostedStep = 'updatePostedStep';
  static const _methodCalcSleep = 'calcSleep';
  static const _methodGetNeedPostSleepList = 'getNeedPostSleepList';
  static const _methodGetSleepDataForPeriod = 'getSleepDataForPeriod';
  static const _methodUpdatePostedSleep = 'updatePostedSleep';
  static const _methodRefreshStepSensor = 'refreshStepSensor';
  static const _methodRefreshClickStepNoti = 'clickStepNotification';

  /// Android, Ios
  static const _methodPhrInit = 'initService';
  static const _methodPhrClose = 'closeService';
  static const _methodGetStepCntForPeriod = 'getStepCntForPeriod';
  static const _methodGetStepDataForPeriod = 'getStepDataForPeriod';
  static const _methodGetTodayStepDataWhenDetect = 'getTodayStepDataWhenDetect';

  final _stepStreamController = StreamController<DailyStepRecord>.broadcast();

  Stream<DailyStepRecord> get stepStream => _stepStreamController.stream;

  initService() async {
    try {
      var msg = await _channel?.invokeMethod<String>(_methodPhrInit);
      Logger.info('msg = $msg');
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }
  }

  stopService() async {
    try {
      await _stepStreamController.close(); // 스트림 컨트롤러 정리
      var result = await _channel?.invokeMethod<bool>(_methodPhrClose);
      Logger.info('success = $result');
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }
  }

  Future<int> getTodayStepCnt() async => getStepCountForPeriod(DateTime.now());

  Future<int> getStepCountForPeriod(DateTime from, [DateTime? to]) async {
    try {
      int? cnt = await _channel?.invokeMethod<int>(
        _methodGetStepCntForPeriod,
        {
          'from': from.toStartUnixTimeStamp(),
          'to': (to ?? from).toEndUnixTimeStamp()
        },
      );
      return cnt ?? 0;
    } catch (e, s) {
      Logger.error('', e: e, s: s);
      return 0;
    }
  }

  Future<List<StepModel>> getStepDataForPeriod(DateTime from,
      [DateTime? to]) async {
    final result = <StepModel>[];
    final callParams = {
      'from': from.toStartUnixTimeStamp(),
      'to': (to ?? from).toEndUnixTimeStamp()
    };

    try {
      final channelResult = await _channel?.invokeListMethod<String>(
          _methodGetStepDataForPeriod, callParams);

      List<StepModel>? stepList = channelResult
          ?.map((e) => PhrStep.fromMap(json.decode(e)))
          .map((e) => StepModel(
              date: e.recordDateTime.toDateTime(), count: e.stepCount))
          .toList();
      Logger.info('stepList = $stepList');
      result.addAll(stepList ?? <StepModel>[]);
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }
    return result;
  }

  Future<List<StepModel>> getNeedPostStepList() async {
    if (DeviceInfo.isIOS) return [];
    var result = <StepModel>[];

    try {
      var channelResult =
          await _channel?.invokeListMethod<String>(_methodGetNeedPostStepList);
      List<StepModel>? stepList = channelResult
          ?.map((e) => PhrStep.fromMap(json.decode(e)))
          .map((e) => StepModel(
              date: e.recordDateTime.toDateTime(), count: e.stepCount))
          .toList();
      result.addAll(stepList ?? <StepModel>[]);
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }

    return result;
  }

  Future<void> updatePostedStep(List<StepModel> timeList) async {
    if (DeviceInfo.isIOS) return;
    try {
      await _channel?.invokeMethod(
        _methodUpdatePostedStep,
        {'time_list': timeList.map((e) => e.date.toUnixTimeStamp()).toList()},
      );
      Logger.info('success');
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }
  }

  // 수면

  Future<void> calcSleep() async {
    if (DeviceInfo.isIOS) return;
    try {
      var needPost = await _channel?.invokeMethod<bool>(_methodCalcSleep);
      Logger.info('needPost = $needPost');
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }
  }

  Future<List<SleepModel>> getNeedPostSleepList() async {
    if (DeviceInfo.isIOS) return [];
    var result = <SleepModel>[];

    try {
      var channelResult =
          await _channel?.invokeListMethod<String>(_methodGetNeedPostSleepList);
      Logger.info('channelResult = $channelResult');

      List<SleepModel>? sleepList = channelResult
          ?.map((e) => PhrSleep.fromMap(json.decode(e)))
          .map(
            (e) => SleepModel(
              date: e.recordDate.toDateTime(),
              startTime: e.startTime.toDateTime(),
              endTime: e.endTime.toDateTime(),
            ),
          )
          .toList();
      Logger.info('sleepList = $sleepList');
      result.addAll(sleepList ?? <SleepModel>[]);
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }

    return result;
  }

  Future<List<SleepModel>> getSleepDataForPeriod(DateTime from,
      [DateTime? to]) async {
    final result = <SleepModel>[];
    final callParams = {
      'from': from.toStartUnixTimeStamp(),
      'to': (to ?? from).toEndUnixTimeStamp()
    };

    try {
      final channelResult = await _channel?.invokeListMethod<String>(
          _methodGetSleepDataForPeriod, callParams);

      List<SleepModel>? sleepList = channelResult
          ?.map((e) => PhrSleep.fromMap(json.decode(e)))
          .map((e) => SleepModel(
                date: e.recordDate.toDateTime(),
                startTime: e.startTime.toDateTime(),
                endTime: e.endTime.toDateTime(),
              ))
          .toList();
      Logger.info('sleepList = $sleepList');
      result.addAll(sleepList ?? <SleepModel>[]);
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }
    return result;
  }

  Future<void> updatePostedSleep(DateTime deleteTime) async {
    if (DeviceInfo.isIOS) return;
    try {
      await _channel?.invokeMethod(
        _methodUpdatePostedSleep,
        {'delete_time': deleteTime.toUnixTimeStamp()},
      );
      Logger.info('success');
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }
  }

  Future<void> refreshStepSensor() async {
    if (DeviceInfo.isIOS) return;
    try {
      await _channel?.invokeMethod(_methodRefreshStepSensor);
      Logger.info('success');
    } catch (e, s) {
      Logger.error('', e: e, s: s);
    }
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _methodRefreshClickStepNoti:
        break;
      case _methodGetTodayStepDataWhenDetect:
        try {
          final List<Object?> resultList = call.arguments as List<Object?>;
          final List<String> stringList = resultList.cast<String>();
          final stepDataList = stringList
              .map((e) => PhrStep.fromMap(json.decode(e)))
              .map((e) => StepModel(
                  date: e.recordDateTime.toDateTime(), count: e.stepCount))
              .toList();
          final dailyStepData = DailyStepRecord(
            date: DateTimeExt.getToday(),
            stepDataList: stepDataList,
          );
          _stepStreamController.add(dailyStepData); // 데이터 스트림에 추가
        } catch (e) {
          Logger.error(e.toString(), e: e, s: StackTrace.current);
          _stepStreamController.addError(e);
        }
        break;
      default:
        return Future<void>.error('Method not defined');
    }
  }
}

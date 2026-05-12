import 'dart:async';

import 'package:icreat_dct/0_data/model/health/daily_sleep_record.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/0_data/model/health/sleep_model.dart';
import 'package:icreat_dct/0_data/model/health/step_model.dart';
// import 'package:icreat_dct/2_repository/apple_health_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/5_channel/phr_channel.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/listener.dart';
import 'package:icreat_dct/7_helper/permission_helper.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class HealthService {
  // final AppleHealthRepository _appleHealthRepository;
  final PermissionHelper _permissionHelper;
  final PhrChannel _phrChannel;
  final PrefRepository _prefRepo;

  final _stepStreamController = StreamController<DailyStepRecord>.broadcast();

  Stream<DailyStepRecord> get stepStream => _stepStreamController.stream;

  StreamSubscription<DailyStepRecord>? _phrStepSubscription;

  final ChangeListener _appleHealthRequestedListener = ChangeListener();
  int addAppleHealthRequestedListener(void Function() callback) {
    return _appleHealthRequestedListener.add(callback);
  }

  void removeAppleHealthRequestedListener(int? id) {
    _appleHealthRequestedListener.remove(id);
  }

  HealthService(
    // this._appleHealthRepository,
    this._permissionHelper,
    this._phrChannel,
    this._prefRepo,
  );

  Future<void> initPhrService() async {
    if (DeviceInfo.isAndroid) {
      await _phrChannel.initService();
    }
  }

  Future<void> requestHealthAuth() async {
    if (DeviceInfo.isIOS) {
      // await _appleHealthRepository.requestHealthAuth();
      _prefRepo.setAppleHealthRequested(true);
      _appleHealthRequestedListener.notify();
    } else {
      await _permissionHelper.requestHealth();
    }
  }

  bool checkAppleHealthRequested() {
    return _prefRepo.appleHealthRequested;
  }

  // --- Step Count ---

  void startListeningStepCount(DateTime start, DateTime end) {
    if (DeviceInfo.isIOS) {
      // _appleHealthRepository.observerStepCount(start, end, (identifier) {
      //   getTodayStepRecord().then(_stepStreamController.add);
      // });
      return;
    }

    // 기존 리스너 취소 후 재구독
    _phrStepSubscription?.cancel();
    _phrStepSubscription = _phrChannel.stepStream.listen(_stepStreamController.add);
  }

  void stopListeningStepCount() {
    _phrStepSubscription?.cancel();
    _phrStepSubscription = null;
  }

  Future<DailyStepRecord> getTodayStepRecord() async {
    final result = await getStepDataForPeriod(
        DateTimeExt.getToday(), DateTime.now().withEndTime());
    return DailyStepRecord(date: DateTimeExt.getToday(), stepDataList: result);
  }

  Future<List<StepModel>> getStepDataForPeriod(DateTime start, DateTime end) async {
    if (DeviceInfo.isIOS) {
      return [];
      // return _appleHealthRepository.getStepDataForPeriod(
      //     start.withStartTime(), end.withEndTime());
    }

    return _phrChannel.getStepDataForPeriod(start.withStartTime(), end.withEndTime());
  }

  Future<List<DailyStepRecord>> getStepRecordsForPeriod(DateTime start, DateTime end) async {
    final result = await getStepDataForPeriod(start, end);
    final Map<DateTime, DailyStepRecord> stepRecords = {};
    for (var step in result) {
      final date = step.date.toLocalize();
      if (stepRecords.containsKey(date)) {
        stepRecords[date]?.stepDataList.add(step);
      } else {
        stepRecords[date] = DailyStepRecord(date: date, stepDataList: [step]);
      }
    }
    return stepRecords.values.toList();
  }

  // --- Sleep ---

  Future<DailySleepRecord> getTodaySleepRecord() async {
    List<SleepModel> result;
    // 자정 이전 수면 시작시간을 얻기 위해 어제 자정부터 오늘 자정까지 데이터를 가져옴
    final from = DateTimeExt.getToday().subtract(Duration(days: 1));
    final to = DateTimeExt.getToday().withEndTime();

    result = await getSleepDataForPeriod(from, to);

    // endTime이 오늘 자정보다 이전인 경우 제외
    result.removeWhere((el) => el.endTime.isBefore(DateTimeExt.getToday()));

    return DailySleepRecord(date: DateTimeExt.getToday(), sleepData: result);
  }

  Future<List<SleepModel>> getSleepDataForPeriod(DateTime start, DateTime end) async {
    if (DeviceInfo.isIOS) {
      // return await _appleHealthRepository.getSleepDataForPeriod(start, end);
      return [];
    }

    return await _phrChannel.getSleepDataForPeriod(start, end);
  }

  Future<List<DailySleepRecord>> getSleepRecordsForPeriod(DateTime start, DateTime end) async {
    final result = await getSleepDataForPeriod(start, end);
    final Map<DateTime, DailySleepRecord> sleepRecords = {};
    for (var sleep in result) {
      final (date, sleepData) = _calculateSleepDate(sleep);
      if (sleepRecords.containsKey(date)) {
        sleepRecords[date]?.sleepData.add(sleepData);
      } else {
        sleepRecords[date] =
            DailySleepRecord(date: date, sleepData: [sleepData]);
      }
    }
    return sleepRecords.values.toList();
  }

  /// 수면 데이터를 분석하여 오후 9시를 기준으로 9시 이전 취침은 전날 수면, 9시 이후 취침은 당일 수면으로 분류
  /// 전날 수면인 경우 startTime의 자정으로 분류
  /// 당일 수면인 경우 endTime의 자정으로 분류
  (DateTime, SleepModel) _calculateSleepDate(SleepModel sleepData) {
    final date = sleepData.date.toLocalize();
    final standardTime = DateTime(date.year, date.month, date.day, 21, 0);

    return sleepData.startTime.isBefore(standardTime) ?
      (sleepData.startTime.withStartTime(), sleepData) :
      (sleepData.endTime.withEndTime(), sleepData);
  }
}

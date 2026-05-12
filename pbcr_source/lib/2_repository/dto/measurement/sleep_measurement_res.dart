import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/measurement/sleep_measurement_model.dart';

part 'sleep_measurement_res.g.dart';

@JsonSerializable()
class SleepMeasurementRes {
  @JsonKey(name: 'usernm')
  final String userName;

  @JsonKey(name: '_MENU_AUTH_LVL')
  final int menuAuthLevel;

  @JsonKey(name: 'userorgannm')
  final String userOrganName;

  @JsonKey(name: '_RSLT_VAL')
  final String resultValue;

  @JsonKey(name: 'userid')
  final String userId;

  @JsonKey(name: 'measurements')
  final List<SleepMeasurementItemRes> measurements;

  SleepMeasurementRes({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });

  factory SleepMeasurementRes.fromJson(Map<String, dynamic> json) =>
      _$SleepMeasurementResFromJson(json);

  Map<String, dynamic> toJson() => _$SleepMeasurementResToJson(this);
}

@JsonSerializable()
class SleepMeasurementItemRes {
  @JsonKey(name: 'UK')
  final int uk;

  @JsonKey(name: 'STDYNO')
  final String studyNo;

  @JsonKey(name: 'PID')
  final int pid;

  @JsonKey(name: 'ORGANCD')
  final String organCd;

  @JsonKey(name: 'IS_SCHEDULED')
  final String isScheduled;

  @JsonKey(name: 'IS_MANUAL')
  final String isManual;

  @JsonKey(name: 'SLEEP_TOTAL_MINUTES')
  final int sleepTotalMinutes;

  @JsonKey(name: 'SLEEP_DEEP_MINUTES')
  final int sleepDeepMinutes;

  @JsonKey(name: 'SLEEP_LIGHT_MINUTES')
  final int sleepLightMinutes;

  @JsonKey(name: 'SLEEP_WAKE_COUNT')
  final int sleepWakeCount;

  @JsonKey(name: 'SLEEP_MEMO')
  final String? sleepMemo;

  SleepMeasurementItemRes({
    required this.uk,
    required this.studyNo,
    required this.pid,
    required this.organCd,
    required this.isScheduled,
    required this.isManual,
    required this.sleepTotalMinutes,
    required this.sleepDeepMinutes,
    required this.sleepLightMinutes,
    required this.sleepWakeCount,
    this.sleepMemo,
  });

  factory SleepMeasurementItemRes.fromJson(Map<String, dynamic> json) =>
      _$SleepMeasurementItemResFromJson(json);

  Map<String, dynamic> toJson() => _$SleepMeasurementItemResToJson(this);
}

extension SleepMeasurementResMapper on SleepMeasurementRes {
  SleepMeasurementModel toModel() => SleepMeasurementModel(
        userName: userName,
        menuAuthLevel: menuAuthLevel,
        userOrganName: userOrganName,
        resultValue: resultValue,
        userId: userId,
        measurements: measurements.map((e) => e.toModel()).toList(),
      );
}

extension SleepMeasurementItemResMapper on SleepMeasurementItemRes {
  SleepMeasurementItemModel toModel() => SleepMeasurementItemModel(
        uk: uk,
        studyNo: studyNo,
        pid: pid,
        organCd: organCd,
        isScheduled: isScheduled,
        isManual: isManual,
        sleepTotalMinutes: sleepTotalMinutes,
        sleepDeepMinutes: sleepDeepMinutes,
        sleepLightMinutes: sleepLightMinutes,
        sleepWakeCount: sleepWakeCount,
        sleepMemo: sleepMemo,
      );
}

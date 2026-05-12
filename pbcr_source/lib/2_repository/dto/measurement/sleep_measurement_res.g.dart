// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_measurement_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SleepMeasurementRes _$SleepMeasurementResFromJson(Map<String, dynamic> json) =>
    SleepMeasurementRes(
      userName: json['usernm'] as String,
      menuAuthLevel: (json['_MENU_AUTH_LVL'] as num).toInt(),
      userOrganName: json['userorgannm'] as String,
      resultValue: json['_RSLT_VAL'] as String,
      userId: json['userid'] as String,
      measurements: (json['measurements'] as List<dynamic>)
          .map((e) =>
              SleepMeasurementItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SleepMeasurementResToJson(
        SleepMeasurementRes instance) =>
    <String, dynamic>{
      'usernm': instance.userName,
      '_MENU_AUTH_LVL': instance.menuAuthLevel,
      'userorgannm': instance.userOrganName,
      '_RSLT_VAL': instance.resultValue,
      'userid': instance.userId,
      'measurements': instance.measurements,
    };

SleepMeasurementItemRes _$SleepMeasurementItemResFromJson(
        Map<String, dynamic> json) =>
    SleepMeasurementItemRes(
      uk: (json['UK'] as num).toInt(),
      studyNo: json['STDYNO'] as String,
      pid: (json['PID'] as num).toInt(),
      organCd: json['ORGANCD'] as String,
      isScheduled: json['IS_SCHEDULED'] as String,
      isManual: json['IS_MANUAL'] as String,
      sleepTotalMinutes: (json['SLEEP_TOTAL_MINUTES'] as num).toInt(),
      sleepDeepMinutes: (json['SLEEP_DEEP_MINUTES'] as num).toInt(),
      sleepLightMinutes: (json['SLEEP_LIGHT_MINUTES'] as num).toInt(),
      sleepWakeCount: (json['SLEEP_WAKE_COUNT'] as num).toInt(),
      sleepMemo: json['SLEEP_MEMO'] as String?,
    );

Map<String, dynamic> _$SleepMeasurementItemResToJson(
        SleepMeasurementItemRes instance) =>
    <String, dynamic>{
      'UK': instance.uk,
      'STDYNO': instance.studyNo,
      'PID': instance.pid,
      'ORGANCD': instance.organCd,
      'IS_SCHEDULED': instance.isScheduled,
      'IS_MANUAL': instance.isManual,
      'SLEEP_TOTAL_MINUTES': instance.sleepTotalMinutes,
      'SLEEP_DEEP_MINUTES': instance.sleepDeepMinutes,
      'SLEEP_LIGHT_MINUTES': instance.sleepLightMinutes,
      'SLEEP_WAKE_COUNT': instance.sleepWakeCount,
      'SLEEP_MEMO': instance.sleepMemo,
    };

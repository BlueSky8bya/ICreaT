// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_measurement_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepMeasurementRes _$StepMeasurementResFromJson(Map<String, dynamic> json) =>
    StepMeasurementRes(
      userName: json['usernm'] as String,
      menuAuthLevel: (json['_MENU_AUTH_LVL'] as num).toInt(),
      userOrganName: json['userorgannm'] as String,
      resultValue: json['_RSLT_VAL'] as String,
      userId: json['userid'] as String,
      measurements: (json['measurements'] as List<dynamic>)
          .map(
              (e) => StepMeasurementItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StepMeasurementResToJson(StepMeasurementRes instance) =>
    <String, dynamic>{
      'usernm': instance.userName,
      '_MENU_AUTH_LVL': instance.menuAuthLevel,
      'userorgannm': instance.userOrganName,
      '_RSLT_VAL': instance.resultValue,
      'userid': instance.userId,
      'measurements': instance.measurements,
    };

StepMeasurementItemRes _$StepMeasurementItemResFromJson(
        Map<String, dynamic> json) =>
    StepMeasurementItemRes(
      uk: (json['UK'] as num).toInt(),
      studyNo: json['STDYNO'] as String,
      pid: (json['PID'] as num).toInt(),
      organCd: json['ORGANCD'] as String,
      isScheduled: json['IS_SCHEDULED'] as String,
      isManual: json['IS_MANUAL'] as String,
      stepTotal: (json['STEP_TOTAL'] as num).toInt(),
      stepDistance: (json['STEP_DISTANCE'] as num).toDouble(),
      stepCalories: (json['STEP_CALORIES'] as num).toDouble(),
      stepMemo: json['STEP_MEMO'] as String?,
    );

Map<String, dynamic> _$StepMeasurementItemResToJson(
        StepMeasurementItemRes instance) =>
    <String, dynamic>{
      'UK': instance.uk,
      'STDYNO': instance.studyNo,
      'PID': instance.pid,
      'ORGANCD': instance.organCd,
      'IS_SCHEDULED': instance.isScheduled,
      'IS_MANUAL': instance.isManual,
      'STEP_TOTAL': instance.stepTotal,
      'STEP_DISTANCE': instance.stepDistance,
      'STEP_CALORIES': instance.stepCalories,
      'STEP_MEMO': instance.stepMemo,
    };

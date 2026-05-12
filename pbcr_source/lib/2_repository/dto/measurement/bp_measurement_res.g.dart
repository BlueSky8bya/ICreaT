// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bp_measurement_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BpMeasurementRes _$BpMeasurementResFromJson(Map<String, dynamic> json) =>
    BpMeasurementRes(
      userName: json['usernm'] as String,
      menuAuthLevel: (json['_MENU_AUTH_LVL'] as num).toInt(),
      userOrganName: json['userorgannm'] as String,
      resultValue: json['_RSLT_VAL'] as String,
      userId: json['userid'] as String,
      measurements: (json['measurements'] as List<dynamic>)
          .map((e) => BpMeasurementItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BpMeasurementResToJson(BpMeasurementRes instance) =>
    <String, dynamic>{
      'usernm': instance.userName,
      '_MENU_AUTH_LVL': instance.menuAuthLevel,
      'userorgannm': instance.userOrganName,
      '_RSLT_VAL': instance.resultValue,
      'userid': instance.userId,
      'measurements': instance.measurements,
    };

BpMeasurementItemRes _$BpMeasurementItemResFromJson(
        Map<String, dynamic> json) =>
    BpMeasurementItemRes(
      uk: (json['UK'] as num).toInt(),
      studyNo: json['STDYNO'] as String,
      pid: (json['PID'] as num).toInt(),
      organCd: json['ORGANCD'] as String,
      isScheduled: json['IS_SCHEDULED'] as String,
      isManual: json['IS_MANUAL'] as String,
      bpSystolic: (json['BP_SYSTOLIC'] as num).toInt(),
      bpDiastolic: (json['BP_DIASTOLIC'] as num).toInt(),
      bpPulse: (json['BP_PULSE'] as num?)?.toInt(),
      bpMemo: json['BP_MEMO'] as String?,
    );

Map<String, dynamic> _$BpMeasurementItemResToJson(
        BpMeasurementItemRes instance) =>
    <String, dynamic>{
      'UK': instance.uk,
      'STDYNO': instance.studyNo,
      'PID': instance.pid,
      'ORGANCD': instance.organCd,
      'IS_SCHEDULED': instance.isScheduled,
      'IS_MANUAL': instance.isManual,
      'BP_SYSTOLIC': instance.bpSystolic,
      'BP_DIASTOLIC': instance.bpDiastolic,
      'BP_PULSE': instance.bpPulse,
      'BP_MEMO': instance.bpMemo,
    };

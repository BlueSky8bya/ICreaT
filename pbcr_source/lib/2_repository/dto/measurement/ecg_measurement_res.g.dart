// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecg_measurement_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EcgMeasurementRes _$EcgMeasurementResFromJson(Map<String, dynamic> json) =>
    EcgMeasurementRes(
      userName: json['usernm'] as String,
      menuAuthLevel: (json['_MENU_AUTH_LVL'] as num).toInt(),
      userOrganName: json['userorgannm'] as String,
      resultValue: json['_RSLT_VAL'] as String,
      userId: json['userid'] as String,
      measurements: (json['measurements'] as List<dynamic>)
          .map((e) => EcgMeasurementItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EcgMeasurementResToJson(EcgMeasurementRes instance) =>
    <String, dynamic>{
      'usernm': instance.userName,
      '_MENU_AUTH_LVL': instance.menuAuthLevel,
      'userorgannm': instance.userOrganName,
      '_RSLT_VAL': instance.resultValue,
      'userid': instance.userId,
      'measurements': instance.measurements,
    };

EcgMeasurementItemRes _$EcgMeasurementItemResFromJson(
        Map<String, dynamic> json) =>
    EcgMeasurementItemRes(
      uk: (json['UK'] as num).toInt(),
      studyNo: json['STDYNO'] as String,
      pid: (json['PID'] as num).toInt(),
      organCd: json['ORGANCD'] as String,
      isScheduled: json['IS_SCHEDULED'] as String,
      isManual: json['IS_MANUAL'] as String,
      ecgDiagnosis: json['ECG_DIAGNOSIS'] as String,
      ecgVentRate: (json['ECG_VENT_RATE'] as num).toInt(),
      ecgPDuration: (json['ECG_P_DURATION'] as num).toInt(),
      ecgPrInterval: (json['ECG_PR_INTERVAL'] as num).toInt(),
      ecgQrsDuration: (json['ECG_QRS_DURATION'] as num).toInt(),
      ecgQtInterval: (json['ECG_QT_INTERVAL'] as num).toInt(),
      ecgQtcInterval: (json['ECG_QTC_INTERVAL'] as num).toInt(),
      ecgNode: json['ECG_NODE'] as String,
      ecgRhythm: json['ECG_RHYTHM'] as String,
      ecgConclusion: json['ECG_CONCLUSION'] as String,
      ecgMemo: json['ECG_MEMO'] as String?,
    );

Map<String, dynamic> _$EcgMeasurementItemResToJson(
        EcgMeasurementItemRes instance) =>
    <String, dynamic>{
      'UK': instance.uk,
      'STDYNO': instance.studyNo,
      'PID': instance.pid,
      'ORGANCD': instance.organCd,
      'IS_SCHEDULED': instance.isScheduled,
      'IS_MANUAL': instance.isManual,
      'ECG_DIAGNOSIS': instance.ecgDiagnosis,
      'ECG_VENT_RATE': instance.ecgVentRate,
      'ECG_P_DURATION': instance.ecgPDuration,
      'ECG_PR_INTERVAL': instance.ecgPrInterval,
      'ECG_QRS_DURATION': instance.ecgQrsDuration,
      'ECG_QT_INTERVAL': instance.ecgQtInterval,
      'ECG_QTC_INTERVAL': instance.ecgQtcInterval,
      'ECG_NODE': instance.ecgNode,
      'ECG_RHYTHM': instance.ecgRhythm,
      'ECG_CONCLUSION': instance.ecgConclusion,
      'ECG_MEMO': instance.ecgMemo,
    };

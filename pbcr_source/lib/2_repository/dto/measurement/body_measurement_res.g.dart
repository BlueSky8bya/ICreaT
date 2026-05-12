// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_measurement_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyMeasurementRes _$BodyMeasurementResFromJson(Map<String, dynamic> json) =>
    BodyMeasurementRes(
      userName: json['usernm'] as String,
      menuAuthLevel: (json['_MENU_AUTH_LVL'] as num).toInt(),
      userOrganName: json['userorgannm'] as String,
      resultValue: json['_RSLT_VAL'] as String,
      userId: json['userid'] as String,
      measurements: (json['measurements'] as List<dynamic>)
          .map(
              (e) => BodyMeasurementItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BodyMeasurementResToJson(BodyMeasurementRes instance) =>
    <String, dynamic>{
      'usernm': instance.userName,
      '_MENU_AUTH_LVL': instance.menuAuthLevel,
      'userorgannm': instance.userOrganName,
      '_RSLT_VAL': instance.resultValue,
      'userid': instance.userId,
      'measurements': instance.measurements,
    };

BodyMeasurementItemRes _$BodyMeasurementItemResFromJson(
        Map<String, dynamic> json) =>
    BodyMeasurementItemRes(
      uk: (json['UK'] as num).toInt(),
      studyNo: json['STDYNO'] as String,
      pid: (json['PID'] as num).toInt(),
      organCd: json['ORGANCD'] as String,
      isScheduled: json['IS_SCHEDULED'] as String,
      isManual: json['IS_MANUAL'] as String,
      bodyWeight: (json['BODY_WEIGHT'] as num).toDouble(),
      bodyBmi: (json['BODY_BMI'] as num?)?.toDouble(),
      bodyFatPercentage: (json['BODY_FAT_PERCENTAGE'] as num?)?.toDouble(),
      bodyBasalMetabolism: (json['BODY_BASAL_METABOLISM'] as num?)?.toDouble(),
      bodySkeletalMusclePercentage:
          (json['BODY_SKELETAL_MUSCLE_PERCENTAGE'] as num?)?.toDouble(),
      bodyVisceralFatLevel:
          (json['BODY_VISCERAL_FAT_LEVEL'] as num?)?.toDouble(),
      bodyAge: (json['BODY_AGE'] as num?)?.toInt(),
      bodyMemo: json['BODY_MEMO'] as String?,
    );

Map<String, dynamic> _$BodyMeasurementItemResToJson(
        BodyMeasurementItemRes instance) =>
    <String, dynamic>{
      'UK': instance.uk,
      'STDYNO': instance.studyNo,
      'PID': instance.pid,
      'ORGANCD': instance.organCd,
      'IS_SCHEDULED': instance.isScheduled,
      'IS_MANUAL': instance.isManual,
      'BODY_WEIGHT': instance.bodyWeight,
      'BODY_BMI': instance.bodyBmi,
      'BODY_FAT_PERCENTAGE': instance.bodyFatPercentage,
      'BODY_BASAL_METABOLISM': instance.bodyBasalMetabolism,
      'BODY_SKELETAL_MUSCLE_PERCENTAGE': instance.bodySkeletalMusclePercentage,
      'BODY_VISCERAL_FAT_LEVEL': instance.bodyVisceralFatLevel,
      'BODY_AGE': instance.bodyAge,
      'BODY_MEMO': instance.bodyMemo,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResultRes _$LoginResultResFromJson(Map<String, dynamic> json) =>
    LoginResultRes(
      resultValue: json['_RSLT_VAL'] as String,
      dctSessionId: json['Dct-Session-Id'] as String?,
      resultMessage: json['_RSLT_MSG'] as String?,
      pid: (json['pid'] as num?)?.toInt(),
      organCode: json['organ_cd'] as String?,
      patName: json['pat_name'] as String?,
    );

Map<String, dynamic> _$LoginResultResToJson(LoginResultRes instance) =>
    <String, dynamic>{
      '_RSLT_VAL': instance.resultValue,
      'Dct-Session-Id': instance.dctSessionId,
      '_RSLT_MSG': instance.resultMessage,
      'pid': instance.pid,
      'organ_cd': instance.organCode,
      'pat_name': instance.patName,
    };

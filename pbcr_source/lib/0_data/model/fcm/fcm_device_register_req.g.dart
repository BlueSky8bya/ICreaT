// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_device_register_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmDeviceRegisterReq _$FcmDeviceRegisterReqFromJson(
        Map<String, dynamic> json) =>
    FcmDeviceRegisterReq(
      studyNo: json['stdy_no'] as String?,
      pid: json['pid'] as String?,
      orgCd: json['org_cd'] as String?,
      deviceToken: json['device_token'] as String,
      deviceType: json['device_type'] as String?,
      appVersion: json['app_version'] as String?,
      deviceModel: json['device_model'] as String?,
      osVersion: json['os_version'] as String?,
    );

Map<String, dynamic> _$FcmDeviceRegisterReqToJson(
        FcmDeviceRegisterReq instance) =>
    <String, dynamic>{
      if (instance.studyNo case final value?) 'stdy_no': value,
      if (instance.pid case final value?) 'pid': value,
      if (instance.orgCd case final value?) 'org_cd': value,
      'device_token': instance.deviceToken,
      'device_type': instance.deviceType,
      if (instance.appVersion case final value?) 'app_version': value,
      if (instance.deviceModel case final value?) 'device_model': value,
      if (instance.osVersion case final value?) 'os_version': value,
    };

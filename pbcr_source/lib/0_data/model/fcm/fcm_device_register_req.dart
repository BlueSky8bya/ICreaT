import 'package:json_annotation/json_annotation.dart';

part 'fcm_device_register_req.g.dart';

@JsonSerializable()
class FcmDeviceRegisterReq {
  @JsonKey(
    name: 'stdy_no',
    includeIfNull: false,
    defaultValue: null,
  )
  final String? studyNo;
  @JsonKey(
    name: 'pid',
    includeIfNull: false,
    defaultValue: null,
  )
  final String? pid;
  @JsonKey(
    name: 'org_cd',
    includeIfNull: false,
    defaultValue: null,
  )
  final String? orgCd;
  @JsonKey(
    name: 'device_token',
    defaultValue: null,
  )
  final String deviceToken;
  @JsonKey(name: 'device_type')
  final String? deviceType;
  @JsonKey(
    name: 'app_version',
    includeIfNull: false,
    defaultValue: null,
  )
  final String? appVersion;
  @JsonKey(
    name: 'device_model',
    includeIfNull: false,
    defaultValue: null,
  )
  final String? deviceModel;
  @JsonKey(
    name: 'os_version',
    includeIfNull: false,
    defaultValue: null,
  )
  final String? osVersion;

  const FcmDeviceRegisterReq({
    this.studyNo,
    this.pid,
    this.orgCd,
    required this.deviceToken,
    this.deviceType,
    this.appVersion,
    this.deviceModel,
    this.osVersion,
  });

  factory FcmDeviceRegisterReq.fromJson(Map<String, dynamic> json) =>
      _$FcmDeviceRegisterReqFromJson(json);

  Map<String, dynamic> toJson() => _$FcmDeviceRegisterReqToJson(this);
}

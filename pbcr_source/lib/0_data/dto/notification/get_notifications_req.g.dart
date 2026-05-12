// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_notifications_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNotificationsReq _$GetNotificationsReqFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['notification_type', 'notification_status'],
  );
  return GetNotificationsReq(
    studyNo: json['stdy_no'] as String,
    pid: json['pid'] as String,
    page: (json['page'] as num?)?.toInt() ?? 1,
    pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
    notificationType: json['notification_type'] as String?,
    notificationStatus: json['notification_status'] as String?,
  );
}

Map<String, dynamic> _$GetNotificationsReqToJson(
        GetNotificationsReq instance) =>
    <String, dynamic>{
      'stdy_no': instance.studyNo,
      'pid': instance.pid,
      'page': instance.page,
      'pageSize': instance.pageSize,
      if (instance.notificationType case final value?)
        'notification_type': value,
      if (instance.notificationStatus case final value?)
        'notification_status': value,
    };

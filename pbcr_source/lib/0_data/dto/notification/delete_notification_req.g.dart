// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_notification_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteNotificationReq _$DeleteNotificationReqFromJson(
        Map<String, dynamic> json) =>
    DeleteNotificationReq(
      notificationId: (json['notification_id'] as num).toInt(),
    );

Map<String, dynamic> _$DeleteNotificationReqToJson(
        DeleteNotificationReq instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
    };

DeleteNotificationsReq _$DeleteNotificationsReqFromJson(
        Map<String, dynamic> json) =>
    DeleteNotificationsReq(
      notificationIds: (json['notification_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$DeleteNotificationsReqToJson(
        DeleteNotificationsReq instance) =>
    <String, dynamic>{
      'notification_ids': instance.notificationIds,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_notification_read_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkNotificationReadReq _$MarkNotificationReadReqFromJson(
        Map<String, dynamic> json) =>
    MarkNotificationReadReq(
      notificationId: (json['notification_id'] as num).toInt(),
    );

Map<String, dynamic> _$MarkNotificationReadReqToJson(
        MarkNotificationReadReq instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
    };

MarkNotificationsReadReq _$MarkNotificationsReadReqFromJson(
        Map<String, dynamic> json) =>
    MarkNotificationsReadReq(
      notificationIds: (json['notification_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$MarkNotificationsReadReqToJson(
        MarkNotificationsReadReq instance) =>
    <String, dynamic>{
      'notification_ids': instance.notificationIds,
    };

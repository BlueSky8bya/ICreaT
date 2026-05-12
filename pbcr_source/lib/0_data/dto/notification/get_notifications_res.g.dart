// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_notifications_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNotificationsRes _$GetNotificationsResFromJson(Map<String, dynamic> json) =>
    GetNotificationsRes(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$GetNotificationsResToJson(
        GetNotificationsRes instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'totalCount': instance.totalCount,
      'totalPages': instance.totalPages,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    NotificationItem(
      notificationId: (json['NOTIFICATION_ID'] as num).toInt(),
      notificationType: json['NOTIFICATION_TYPE'] as String,
      notificationDate: json['NOTIFICATION_DATE'] as String,
      notificationTime: json['NOTIFICATION_TIME'] as String,
      notificationTitle: json['NOTIFICATION_TITLE'] as String,
      notificationMessage: json['NOTIFICATION_MESSAGE'] as String,
      status: json['STATUS'] as String,
      visitSeq: json['VISIT_SEQ'] as String?,
      visitName: json['VISIT_NAME'] as String?,
      visitDate: json['VISIT_DATE'] as String?,
    );

Map<String, dynamic> _$NotificationItemToJson(NotificationItem instance) =>
    <String, dynamic>{
      'NOTIFICATION_ID': instance.notificationId,
      'NOTIFICATION_TYPE': instance.notificationType,
      'NOTIFICATION_DATE': instance.notificationDate,
      'NOTIFICATION_TIME': instance.notificationTime,
      'NOTIFICATION_TITLE': instance.notificationTitle,
      'NOTIFICATION_MESSAGE': instance.notificationMessage,
      'STATUS': instance.status,
      'VISIT_SEQ': instance.visitSeq,
      'VISIT_NAME': instance.visitName,
      'VISIT_DATE': instance.visitDate,
    };

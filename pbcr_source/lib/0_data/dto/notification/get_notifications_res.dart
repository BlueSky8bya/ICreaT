import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:icreat_dct/0_data/model/notififcation/notification_model.dart';
import 'package:icreat_dct/0_data/model/notififcation/notification_type.dart';

part 'get_notifications_res.g.dart';

@JsonSerializable()
class GetNotificationsRes {
  final List<NotificationItem> notifications;

  @JsonKey(name: 'totalCount')
  final int totalCount;

  @JsonKey(name: 'totalPages')
  final int totalPages;

  @JsonKey(name: 'page')
  final int page;

  @JsonKey(name: 'pageSize')
  final int pageSize;

  const GetNotificationsRes({
    required this.notifications,
    required this.totalCount,
    required this.totalPages,
    required this.page,
    required this.pageSize,
  });

  factory GetNotificationsRes.fromJson(Map<String, dynamic> json) =>
      _$GetNotificationsResFromJson(json);

  Map<String, dynamic> toJson() => _$GetNotificationsResToJson(this);
}

@JsonSerializable()
class NotificationItem {
  @JsonKey(name: 'NOTIFICATION_ID')
  final int notificationId;

  @JsonKey(name: 'NOTIFICATION_TYPE')
  final String notificationType;

  @JsonKey(name: 'NOTIFICATION_DATE')
  final String notificationDate;

  @JsonKey(name: 'NOTIFICATION_TIME')
  final String notificationTime;

  @JsonKey(name: 'NOTIFICATION_TITLE')
  final String notificationTitle;

  @JsonKey(name: 'NOTIFICATION_MESSAGE')
  final String notificationMessage;

  @JsonKey(name: 'STATUS')
  final String status;

  @JsonKey(name: 'VISIT_SEQ')
  final String? visitSeq;

  @JsonKey(name: 'VISIT_NAME')
  final String? visitName;

  @JsonKey(name: 'VISIT_DATE')
  final String? visitDate;

  const NotificationItem({
    required this.notificationId,
    required this.notificationType,
    required this.notificationDate,
    required this.notificationTime,
    required this.notificationTitle,
    required this.notificationMessage,
    required this.status,
    this.visitSeq,
    this.visitName,
    this.visitDate,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationItemToJson(this);
}

extension NotificationItemExt on NotificationItem {
  NotificationModel toModel() {
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm", 'ko_KR');
    final notificationDateTime = format.tryParse('$notificationDate $notificationTime');
    final visitDate = this.visitDate != null ? DateTime.parse(this.visitDate!) : null;

    return NotificationModel(
      id: notificationId,
      type: NotificationType.fromString(notificationType),
      title: notificationTitle,
      content: notificationMessage,
      createdAt: notificationDateTime ?? DateTime.now(),
      status: status,
      visitSeq: visitSeq,
      visitName: visitName,
      visitDate: visitDate,
      isRead: status == 'READ',
    );
  }
}

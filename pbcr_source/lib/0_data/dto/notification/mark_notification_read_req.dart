import 'package:json_annotation/json_annotation.dart';

part 'mark_notification_read_req.g.dart';

@JsonSerializable()
class MarkNotificationReadReq {
  @JsonKey(name: 'notification_id')
  final int notificationId;

  const MarkNotificationReadReq({
    required this.notificationId,
  });

  factory MarkNotificationReadReq.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationReadReqFromJson(json);

  Map<String, dynamic> toJson() => _$MarkNotificationReadReqToJson(this);
}

@JsonSerializable()
class MarkNotificationsReadReq {
  @JsonKey(name: 'notification_ids')
  final List<int> notificationIds;

  const MarkNotificationsReadReq({
    required this.notificationIds,
  });

  factory MarkNotificationsReadReq.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationsReadReqFromJson(json);

  Map<String, dynamic> toJson() => _$MarkNotificationsReadReqToJson(this);
}

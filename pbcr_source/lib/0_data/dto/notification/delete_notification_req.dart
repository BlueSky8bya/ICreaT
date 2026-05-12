import 'package:json_annotation/json_annotation.dart';

part 'delete_notification_req.g.dart';

@JsonSerializable()
class DeleteNotificationReq {
  @JsonKey(name: 'notification_id')
  final int notificationId;

  const DeleteNotificationReq({
    required this.notificationId,
  });

  factory DeleteNotificationReq.fromJson(Map<String, dynamic> json) =>
      _$DeleteNotificationReqFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteNotificationReqToJson(this);
}

@JsonSerializable()
class DeleteNotificationsReq {
  @JsonKey(name: 'notification_ids')
  final List<int> notificationIds;

  const DeleteNotificationsReq({
    required this.notificationIds,
  });

  factory DeleteNotificationsReq.fromJson(Map<String, dynamic> json) =>
      _$DeleteNotificationsReqFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteNotificationsReqToJson(this);
}

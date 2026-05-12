import 'package:json_annotation/json_annotation.dart';

part 'get_notifications_req.g.dart';

@JsonSerializable()
class GetNotificationsReq {
  @JsonKey(name: 'stdy_no')
  final String studyNo;

  final String pid;

  // @JsonKey(name: 'org_cd')
  // final String orgCd;

  final int page;

  @JsonKey(name: 'pageSize')
  final int pageSize;

  @JsonKey(
    name: 'notification_type',
    disallowNullValue: true,
  )
  final String? notificationType;

  @JsonKey(
    name: 'notification_status',
    disallowNullValue: true,
  )
  final String? notificationStatus;

  const GetNotificationsReq({
    required this.studyNo,
    required this.pid,
    // required this.orgCd,
    this.page = 1,
    this.pageSize = 10,
    this.notificationType,
    this.notificationStatus,
  });

  factory GetNotificationsReq.fromJson(Map<String, dynamic> json) =>
      _$GetNotificationsReqFromJson(json);

  Map<String, dynamic> toJson() => _$GetNotificationsReqToJson(this);
}

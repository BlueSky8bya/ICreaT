import 'package:icreat_dct/0_data/model/local_notification/local_notification_id.dart';

class LocalNotificationInstanceEntity {
  final LocalNotificationID id;
  final int ruleId;
  final DateTime scheduledTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  LocalNotificationInstanceEntity({
    required this.id,
    required this.ruleId,
    required this.scheduledTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id.notiId,
      'rule_id': ruleId,
      'scheduled_time': scheduledTime.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory LocalNotificationInstanceEntity.fromJson(Map<String, dynamic> json) {
    return LocalNotificationInstanceEntity(
      id: LocalNotificationID.fromId(json['id'] as int),
      ruleId: json['rule_id'] as int,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

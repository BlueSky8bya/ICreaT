import 'package:icreat_dct/0_data/model/local_notification/local_notification_id.dart';

class LocalNotificationInstance {
  /// 알림 자체 ID
  final LocalNotificationID id;

  final int ruleId;
  final DateTime scheduledTime;

  LocalNotificationInstance({
    required this.id,
    required this.ruleId,
    required this.scheduledTime,
  });
}

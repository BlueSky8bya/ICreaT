import 'package:icreat_dct/0_data/model/local_notification/local_notification_id.dart';

class LocalNotificationInstanceCreateReq {
  final LocalNotificationID id;
  final int ruleId;
  final String description;
  final DateTime scheduledTime;

  LocalNotificationInstanceCreateReq({
    required this.id,
    required this.ruleId,
    required this.description,
    required this.scheduledTime,
  });
}

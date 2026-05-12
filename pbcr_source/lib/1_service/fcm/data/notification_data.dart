import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationData {
  NotificationData({
    required this.notiId,
    required this.details,
  });

  final int notiId;
  final NotificationDetails details;

  @override
  String toString() => 'NotificationType(notiId: $notiId, details: $details)';
}

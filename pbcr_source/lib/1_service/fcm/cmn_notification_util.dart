import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:icreat_dct/1_service/fcm/base/base_notification_util.dart';
import 'package:icreat_dct/1_service/fcm/base/base_push_data.dart';
import 'package:icreat_dct/1_service/fcm/cmn_push_util.dart';
import 'package:icreat_dct/1_service/fcm/data/notification_data.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/theme/color_hue.dart';

enum NotificationType { dose, hospital, friend, important, chat, unknown }

extension NotificationTypeExt on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.dose:
        return "dose";
      case NotificationType.hospital:
        return "hospital";
      case NotificationType.friend:
        return "friend";
      case NotificationType.important:
        return "important";
      case NotificationType.chat:
        return "chat";
      case NotificationType.unknown:
        return "unknown";
    }
  }
}

class CMNNotificationUtil extends BaseNotificationUtil {
  CMNNotificationUtil({required CMNPushUtil pushUtil})
      : super(pushUtil: pushUtil);

  final Map<String, NotificationData> _notificationDetails = {
    NotificationType.unknown.name: NotificationData(
      notiId: 10104,
      details: const NotificationDetails(
        android: AndroidNotificationDetails(
          'CAREEASE_NOTIFICATION_40_DEFAULT',
          '기타 알림',
          color: ColorHue.purple400,
        ),
      ),
    ),
    NotificationType.dose.name: NotificationData(
      notiId: 10102,
      details: const NotificationDetails(
        android: AndroidNotificationDetails(
          'CAREEASE_NOTIFICATION_10_DOSE',
          '복약 일정',
          color: ColorHue.purple400,
        ),
      ),
    ),
    NotificationType.friend.name: NotificationData(
      notiId: 10101,
      details: const NotificationDetails(
        android: AndroidNotificationDetails(
          'CAREEASE_NOTIFICATION_30_FRIEND',
          '친구',
          color: ColorHue.purple400,
        ),
      ),
    ),
    NotificationType.hospital.name: NotificationData(
      notiId: 10103,
      details: const NotificationDetails(
        android: AndroidNotificationDetails(
          'CAREEASE_NOTIFICATION_20_NEW_HOSPITAL',
          '병원',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          color: ColorHue.purple400,
        ),
      ),
    ),
    NotificationType.important.name: NotificationData(
      notiId: 10115,
      details: const NotificationDetails(
        android: AndroidNotificationDetails(
          'CAREEASE_NOTIFICATION_25_IMPORTANT',
          '중요 알림',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          color: ColorHue.purple400,
        ),
      ),
    ),
    NotificationType.chat.name: NotificationData(
      notiId: 10120,
      details: const NotificationDetails(
        android: AndroidNotificationDetails(
          'CAREEASE_NOTIFICATION_25_IMPORTANT',
          '문의',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          color: ColorHue.purple400,
        ),
      ),
    ),
  };

  @override
  String get logoName => 'ic_icon';

  @override
  NotificationData? getNotificationTypeFromName(String name) {
    return _notificationDetails[name];
  }

  @override
  NotificationData getDefaultNotificationData() {
    return _notificationDetails[NotificationType.unknown.name]!;
  }

  @override
  void showFromPushData(BasePushData pushData) {
    Logger.info('pushData = $pushData', tag: tag);
    show(
      typeName: NotificationType.unknown.name,
      title: pushData.title,
      body: pushData.body,
      payload: pushData.toJson(),
    );
  }
}

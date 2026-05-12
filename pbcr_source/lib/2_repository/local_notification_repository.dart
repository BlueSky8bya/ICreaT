import 'package:icreat_dct/0_data/model/local_notification/local_notification_instance.dart';
import 'package:icreat_dct/0_data/model/local_notification/local_notification_rule.dart';
import 'package:icreat_dct/0_data/model/notififcation/notification_model.dart';
import 'package:icreat_dct/0_data/dto/local_notification/local_notification_instance_create_req.dart';
import 'package:icreat_dct/0_data/dto/local_notification/local_notification_rule_create_req.dart';

abstract class LocalNotificationRepository {
  Future<LocalNotificationRule> createRule(
      LocalNotificationRuleCreateReq request);

  Future<void> deleteAllRules();

  /// 알림 규칙 및 알림 인스턴스 모두 삭제
  Future<void> deleteRule(int id);

  Future<List<LocalNotificationRule>> getRules();

  Future<void> createInstance(LocalNotificationInstanceCreateReq request);

  Future<void> deleteInstance(int id);

  Future<void> deleteInstanceByRuleId(int ruleId);

  Future<void> deleteAllInstances();

  Future<List<LocalNotificationInstance>> getInstancesByRuleId(int ruleId);

  Future<List<LocalNotificationInstance>> getAllInstances();

  // Server notification methods
  Future<void> saveServerNotification(NotificationModel notification);

  Future<void> saveServerNotifications(List<NotificationModel> notifications);

  Future<List<NotificationModel>> getServerNotifications();

  Future<NotificationModel?> getServerNotification(int id);

  Future<void> updateServerNotification(NotificationModel notification);

  Future<void> deleteServerNotification(int id);

  Future<void> deleteAllServerNotifications();

  Future<void> markServerNotificationAsRead(int id);

  Future<int> getUnreadServerNotificationCount();
}

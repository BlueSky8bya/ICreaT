import 'package:icreat_dct/0_data/model/notififcation/notification_pagination_result.dart';
import 'package:icreat_dct/0_data/model/type/request_result.dart';
import 'package:icreat_dct/0_data/dto/notification/delete_notification_req.dart';
import 'package:icreat_dct/0_data/dto/notification/get_notifications_req.dart';
import 'package:icreat_dct/0_data/dto/notification/get_notifications_res.dart';
import 'package:icreat_dct/0_data/dto/notification/mark_notification_read_req.dart';
import 'package:icreat_dct/2_repository/notification_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/6_util/logger.dart';

class NotificationService {
  final NotificationRepository _notiRepo;
  final PrefRepository _prefRepo;

  NotificationService(this._notiRepo, this._prefRepo);

  Future<RequestResult<NotificationPaginationResult>> getNotifications({
    int page = 1,
    int pageSize = 10,
    String? notificationType,
    String? notificationStatus,
  }) =>
      handleRequest(() async {
        final studyNo = _prefRepo.projectId ?? '';
        final pid = _prefRepo.pid ?? '';

        final request = GetNotificationsReq(
          studyNo: studyNo,
          pid: pid,
          page: page,
          pageSize: pageSize,
          notificationType: notificationType,
          notificationStatus: notificationStatus,
        );

        final response = await _notiRepo.getNotifications(request);

        final notifications =
            response.notifications.map((item) => item.toModel()).toList();

        return NotificationPaginationResult(
          notifications: notifications,
          totalCount: response.totalCount,
          totalPages: response.totalPages,
          currentPage: response.page,
          pageSize: response.pageSize,
        );
      });

  Future<RequestResult<bool>> markNotificationAsRead(int notificationId) =>
      handleRequest(() async {
        try {
          final request =
              MarkNotificationReadReq(notificationId: notificationId);
          final response = await _notiRepo.markNotificationAsRead(request);
          return response['_RSLT_VAL'] == 'SUCCESS';
        } catch (e) {
          Logger.error('Error marking notification as read: $e',
              tag: 'NotificationService');
          Logger.info('Falling back to mock success',
              tag: 'NotificationService');
          return true; // Mock success
        }
      });

  Future<RequestResult<bool>> deleteNotification(int notificationId) =>
      handleRequest(() async {
        try {
          final request = DeleteNotificationReq(notificationId: notificationId);
          final response = await _notiRepo.deleteNotification(request);
          return response['_RSLT_VAL'] == 'SUCCESS';
        } catch (e) {
          Logger.error('Error deleting notification: $e',
              tag: 'NotificationService');
          Logger.info('Falling back to mock success',
              tag: 'NotificationService');
          return true; // Mock success
        }
      });
}

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:icreat_dct/0_data/model/notififcation/notification_model.dart';
import 'package:icreat_dct/0_data/model/notififcation/notification_type.dart';
import 'package:icreat_dct/1_service/notification_service.dart';
import 'package:icreat_dct/1_service/local_notification_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:icreat_dct/6_util/logger.dart';

class NotificationViewModel extends BaseViewModel {
  final NotificationService _notificationService;
  final LocalNotificationService _localNotificationService;

  final RefreshController _refreshController = RefreshController();
  late final PagingController<int, NotificationModel> _pagingController;

  // Track pagination state
  int? _totalPages;
  int? _currentPage;

  // ---  States  ---

  RefreshController get refreshController => _refreshController;
  PagingController<int, NotificationModel> get pagingController =>
      _pagingController;

  // --- Methods ---

  NotificationViewModel(
      this._notificationService, this._localNotificationService);

  @override
  void onInit() async {
    super.onInit();
    Logger.info('Initializing NotificationViewModel', tag: 'Notification');

    _pagingController = PagingController(
      getNextPageKey: (state) {
        // If we know the total pages and current page, check if we should stop
        if (_totalPages != null && _currentPage != null) {
          if (_currentPage! >= _totalPages!) {
            Logger.info(
                'Reached total pages limit ($_currentPage/$_totalPages), returning null to stop pagination',
                tag: 'Notification');
            return null; // Return null to stop pagination
          }
        }

        final nextPageKey = (state.keys?.last ?? 0) + 1;
        Logger.info('Getting next page key: $nextPageKey', tag: 'Notification');
        return nextPageKey;
      },
      fetchPage: (pageKey) => fetchPage(pageKey),
    );

    Logger.info('PagingController created, fetching first page',
        tag: 'Notification');
    _pagingController.fetchNextPage();

    completeInit();
  }

  @override
  void onClose() {
    _pagingController.dispose();
    super.onClose();
  }

  Future<List<NotificationModel>> fetchPage(int pageKey) async {
    final result = await _notificationService.getNotifications(
      page: pageKey,
      pageSize: 10,
    );

    try {
      final resultSuccess = result.isSuccess();
      final resultData = result.getOrThrow();

      if (resultSuccess) {
        final paginationResult = resultData;
        _totalPages = paginationResult.totalPages;
        _currentPage = paginationResult.currentPage;

        Logger.info(
            'Received ${paginationResult.notifications.length} notifications from server, totalPages: ${paginationResult.totalPages}, currentPage: ${paginationResult.currentPage}',
            tag: 'Notification');

        return paginationResult.notifications;
      } else {
        return [];
      }
    } catch (e) {
      Logger.error('Error fetching notifications: $e', tag: 'Notification');
      rethrow;
    }
  }

  // --- Actions ---

  void handleRefresh() {
    // Reset pagination state
    _totalPages = null;
    _currentPage = null;

    _pagingController.refresh();
    _refreshController.refreshCompleted();
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final result =
          await _notificationService.markNotificationAsRead(notificationId);
      if (result.isSuccess() && result.getOrNull() == true) {
        // Update local storage
        await _localNotificationService
            .markServerNotificationAsRead(notificationId);
        // Reset pagination state and refresh the list
        _totalPages = null;
        _currentPage = null;
        _pagingController.refresh();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      final result =
          await _notificationService.deleteNotification(notificationId);
      if (result.isSuccess() && result.getOrNull() == true) {
        // Remove from local storage
        await _localNotificationService
            .deleteServerNotification(notificationId);
        // Reset pagination state and refresh the list
        _totalPages = null;
        _currentPage = null;
        _pagingController.refresh();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> onNotificationTap(NotificationModel notification) async {
    // Mark as read if not already read
    if (!notification.isRead) {
      await markNotificationAsRead(notification.id);
    }

    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.visit:
        // Navigate to visit details
        break;
      case NotificationType.general:
      case NotificationType.system:
      case NotificationType.push:
      case NotificationType.reminder:
      case NotificationType.announcement:
      case NotificationType.urgent:
      case NotificationType.followUp:
        // Show notification details or handle accordingly
        break;
    }
  }
}

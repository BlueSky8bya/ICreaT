import 'package:icreat_dct/0_data/model/notififcation/notification_model.dart';

class NotificationPaginationResult {
  final List<NotificationModel> notifications;
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  const NotificationPaginationResult({
    required this.notifications,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  bool get hasMorePages => currentPage < totalPages;
  bool get isLastPage => currentPage >= totalPages;
}

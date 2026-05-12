import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:icreat_dct/0_data/model/notififcation/notification_model.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/refresher/refresher.dart';
import 'package:icreat_dct/3_view/components/wrapper/init_wrap.dart';
import 'package:icreat_dct/3_view/navbar/notification/notification_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

import 'components/notification_tile.dart';

class NotificationView extends GetView<NotificationViewModel> {
  const NotificationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InitWrap(
      controller: controller,
      builder: () => SafeScaffold(
        backgroundColor: context.bgPrimaryHoverPressed,
        child: PagingListener(
          controller: controller.pagingController,
          builder: (context, state, fetchNextPage) => Refresher(
            controller: controller.refreshController,
            onRefresh: controller.handleRefresh,
            // Container로 감싸줘야 스크롤 내렸을 때 상단에 색상이 달라지지 않더라
            child: PagedListView<int, NotificationModel>.separated(
              state: state,
              fetchNextPage: fetchNextPage,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) => NotificationTile(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: context.bgPrimary,
                  notification: item,
                  onTap: () => controller.onNotificationTap(item),
                  onDelete: () => controller.deleteNotification(item.id),
                ),
                noItemsFoundIndicatorBuilder: (context) =>
                    _NoItemsFoundIndicator(),
                firstPageErrorIndicatorBuilder: (context) => _ErrorIndicator(
                  onRetry: controller.handleRefresh,
                ),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoItemsFoundIndicator extends StatelessWidget {
  const _NoItemsFoundIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('알림이 없습니다.'),
    );
  }
}

class _ErrorIndicator extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorIndicator({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Text('알림을 불러오는데 실패했습니다.'),
          SolidButton(
            text: '다시 시도',
            onTap: onRetry,
          ).primary(context).large,
        ],
      ),
    );
  }
}

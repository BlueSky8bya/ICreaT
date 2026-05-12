import 'package:flutter/material.dart';
import 'package:icreat_dct/0_data/model/notififcation/notification_model.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NotificationTile({
    super.key,
    required this.notification,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('알림 삭제'),
              content: const Text('이 알림을 삭제하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('삭제'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete?.call();
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Icon(
                notification.type.icon,
                color: notification.isRead
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.type.title,
                          style:
                              TextStyles.caption1.medium.primaryColor(context),
                        ),
                        Text(
                          notification.formattedCreatedAt,
                          style: TextStyles.caption1.tertiaryColor(context),
                        ),
                      ],
                    ),
                    Text(
                      notification.title,
                      style: TextStyles.body1.semiBold.primaryColor(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.content,
                      style: TextStyles.body2.regular.secondaryColor(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

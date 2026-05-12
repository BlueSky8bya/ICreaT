import 'package:icreat_dct/0_data/model/notififcation/notification_type.dart';

class NotificationModel {
  final int id;
  final NotificationType type;
  final String title;
  final String content;
  final DateTime createdAt;
  final String status;
  final String? visitSeq;
  final String? visitName;
  final DateTime? visitDate;
  final String? visitsApplies;
  final String? subjectsApplies;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.status,
    this.visitSeq,
    this.visitName,
    this.visitDate,
    this.visitsApplies,
    this.subjectsApplies,
    this.isRead = false,
  });

  String get formattedCreatedAt {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays > 0) {
      return '${diff.inDays}일 전';
    }

    if (diff.inHours > 0) {
      return '${diff.inHours}시간 전';
    }

    if (diff.inMinutes > 0) {
      return '${diff.inMinutes}분 전';
    }

    if (diff.inSeconds >= 0) {
      if (diff.inSeconds < 20) {
        return "방금 전";
      }
      return '${diff.inSeconds}초 전';
    }

    return ""; // TODO: check when negative value comes out.
  }

  NotificationModel copyWith({
    int? id,
    NotificationType? type,
    String? title,
    String? content,
    DateTime? createdAt,
    String? status,
    String? visitSeq,
    String? visitName,
    DateTime? visitDate,
    String? visitsApplies,
    String? subjectsApplies,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      visitSeq: visitSeq ?? this.visitSeq,
      visitName: visitName ?? this.visitName,
      visitDate: visitDate ?? this.visitDate,
      visitsApplies: visitsApplies ?? this.visitsApplies,
      subjectsApplies: subjectsApplies ?? this.subjectsApplies,
      isRead: isRead ?? this.isRead,
    );
  }
}

class LocalNotificationPayload {
  final int id;
  final String title;
  final String body;
  final String? payload;

  LocalNotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
  });

  bool get isEmpty => title.isEmpty || body.isEmpty;
}
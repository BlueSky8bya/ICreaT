import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:icreat_dct/1_service/fcm/base/base_push_data.dart';
import 'package:icreat_dct/1_service/fcm/base/base_push_util.dart';
import 'package:icreat_dct/1_service/fcm/data/notification_data.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';

abstract class BaseNotificationUtil {
  BaseNotificationUtil({required this.pushUtil});

  final tag = 'Notification';
  final BasePushUtil pushUtil;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static const Map<String, String> exceptionalTimeZoneMappings = {
    'Eire': 'Europe/Dublin',
    'GMT': 'Africa/Accra',
    'Etc/UTC': 'UTC',
  };

  Future<void> initialize() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initSettings = _makeInitSettings();

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _listenOnForegroundNotiForAndroid,
    );

    await _requestPermissionIOS();
    await _setTimeZone();
  }

  InitializationSettings _makeInitSettings() {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(logoName);
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            // onDidReceiveLocalNotification: _listenOnForegroundNotiForIOS,
            );
    return InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
  }

  String get logoName;

  void _listenOnForegroundNotiForAndroid(NotificationResponse response) async {
    Logger.info('payload : ${response.payload}', tag: tag);

    pushUtil.onClick(notiPayload: response.payload);
  }

  Future<void> _requestPermissionIOS() async {
    bool? result = false;
    if (DeviceInfo.isIOS) {
      result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    Logger.info('initialize permission result = $result', tag: tag);
  }

  Future<void> requestPermissionAndroid() async {
    bool? result = false;
    if (DeviceInfo.isAndroid) {
      result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    Logger.info('initialize permission result = $result', tag: tag);
  }

  Future<void> _setTimeZone() async {
    tz.initializeTimeZones();
    var timeZoneName = await _getLocalTimeZoneName();
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e, s) {
      Logger.error('$e', tag: tag, e: e, s: s);
      timeZoneName = 'Africa/Accra';
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }
  }

  Future<String> _getLocalTimeZoneName() async {
    var timeZoneName = tz.local.name;
    if (exceptionalTimeZoneMappings.containsKey(timeZoneName)) {
      timeZoneName = exceptionalTimeZoneMappings[timeZoneName]!;
    }
    return timeZoneName;
  }

  void schedule({
    required String typeName,
    required String title,
    required String body,
    required DateTime scheduleTime,
    String? payload,
  }) async {
    final type = getNotificationTypeFromName(typeName);
    Logger.info('typeName = $typeName, time = $scheduleTime');
    if (type != null) {
      Logger.info('type = $type');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        _uniqueNotiId,
        title,
        body,
        tz.TZDateTime.from(scheduleTime, tz.local),
        type.details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    }
  }

  void cancel(int id) async {
    Logger.debug('cancel : id = $id');
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<AndroidBitmap<Object>?> fetchBitmapFromUrl({
    required String url,
  }) async {
    final dio = Dio();

    final response = await dio.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    if (response.statusCode == 200) {
      Uint8List contentsBytes = response.data;
      return ByteArrayAndroidBitmap(contentsBytes);
    }
    return null;
  }

  void show({
    required String typeName,
    AndroidBitmap<Object>? image,
    String? title,
    String? body,
    String? payload,
  }) async {
    if (title != null || body != null) {
      var notiData = getNotificationTypeFromName(typeName);
      
      // typeName에 해당하는 NotificationData가 없으면 기본값 사용
      notiData ??= getDefaultNotificationData();
      
      await flutterLocalNotificationsPlugin.show(
        _uniqueNotiId,
        title,
        body,
        notiData.details.android != null && image != null
            ? copyDetailsWithImage(
                details: notiData.details.android!,
                image: image,
              )
            : notiData.details,
        payload: payload,
      );
    }
  }

  int get _uniqueNotiId => DateTime.now().millisecondsSinceEpoch % 2147483647;

  NotificationDetails copyDetailsWithImage({
    required AndroidNotificationDetails details,
    required AndroidBitmap<Object> image,
  }) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          details.channelId,
          details.channelName,
          importance: details.importance,
          priority: details.priority,
          color: details.color,
          playSound: details.playSound,
          sound: details.sound,
          largeIcon: image,
          styleInformation: BigPictureStyleInformation(
            image,
            hideExpandedLargeIcon: true,
          ),
        ),
      );

  NotificationData? getNotificationTypeFromName(String name);

  NotificationData getDefaultNotificationData();

  void showFromPushData(BasePushData pushData);

  /// 앱 종료된 후 notification 클릭했을 때 처리
  Future<String?> getInitNotiPayload() async =>
      (await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails())
          ?.notificationResponse
          ?.payload;
}

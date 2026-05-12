import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:icreat_dct/1_service/fcm/base/base_notification_util.dart';
import 'package:icreat_dct/1_service/fcm/base/base_push_data.dart';
import 'package:icreat_dct/1_service/fcm/base/base_push_util.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';

abstract class BaseFcmService {
  BaseFcmService({
    required this.pushUtil,
    required this.notiUtil,
  });
  final tag = 'FCM';
  final BasePushUtil pushUtil;
  final BaseNotificationUtil notiUtil;

  Future<void> init() async {
    Logger.info('Starting FCM initialization...', tag: tag);

    try {
      await Firebase.initializeApp();
      Logger.info('Firebase initialized successfully', tag: tag);
    } catch (e, s) {
      Logger.error('Firebase initialization failed', e: e, s: s, tag: tag);
    }

    try {
      await _setOptions();
      Logger.info('FCM options set successfully', tag: tag);
    } catch (e, s) {
      Logger.error('Failed to set FCM options', e: e, s: s, tag: tag);
    }

    try {
      await _requestPermission();
      Logger.info('FCM permissions requested', tag: tag);
    } catch (e, s) {
      Logger.error('Failed to request FCM permissions', e: e, s: s, tag: tag);
    }

    initListenOnBackgroundMsg();
    _setListenOnForegroundMsg();
    _setListenOnPausedMsg();

    try {
      await refreshToken();
      Logger.info('FCM token refresh completed', tag: tag);
    } catch (e, s) {
      Logger.error('Failed to refresh FCM token', e: e, s: s, tag: tag);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(saveFcmToken);
    Logger.info('FCM initialization completed', tag: tag);
  }

  Future<void> _setOptions() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _requestPermission() async {
    if (DeviceInfo.isIOS) {
      var settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      Logger.info(
        'user granted permission : ${settings.authorizationStatus}',
        tag: tag,
      );
    }
  }

  /// static 메서드를 할당해야 함
  /// ```dart
  /// FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  /// ```
  @pragma('vm:entry-point')
  void initListenOnBackgroundMsg();

  void _setListenOnForegroundMsg() {
    // 앱 실행된 상태에서 notification 클릭했을 때 처리
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      Logger.info('onMessageOpenedApp.listen data = ${msg.data}', tag: tag);
      pushUtil.onClick(fcmMsg: msg);
    });
  }

  void _setListenOnPausedMsg() {
    FirebaseMessaging.onMessage.listen(
      (msg) => _handleMessage(msg),
      onError: (e) => Logger.error('onMessage.listen onError', e: e, tag: tag),
      onDone: () => Logger.info('onMessage.listen onDone', tag: tag),
    );
  }

  void _handleMessage(RemoteMessage msg) {
    Logger.info('remoteMessage data = ${msg.data}', tag: tag);

    var pushData = pushUtil.getPushDataFromFcmMsg(msg);
    if (pushData != null) {
      actionWhenRecvPush(pushData);
      if (DeviceInfo.isAndroid) {
        notiUtil.showFromPushData(pushData);
      }
    }
  }

  void actionWhenRecvPush(BasePushData pushData);

  Future<void> refreshToken() async {
    final getToken = await _getFcmToken();
    Logger.info('savedToken = $savedFcmToken, getToken = $getToken', tag: tag);

    if (getToken == null || getToken.isEmpty) return;

    if (savedFcmToken != getToken) {
      await saveFcmToken(getToken);
    }
  }

  Future<String?> _getFcmToken() async {
    const maxRetries = 3;
    const baseDelay = Duration(seconds: 2);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        Logger.info(
            'Attempting to get FCM token (attempt $attempt/$maxRetries)',
            tag: tag);
        return await FirebaseMessaging.instance.getToken();
      } catch (e, s) {
        Logger.error('FCM get token Error (attempt $attempt/$maxRetries)',
            e: e, s: s, tag: tag);

        if (attempt == maxRetries) {
          Logger.error('Failed to get FCM token after $maxRetries attempts',
              tag: tag);
          return null;
        }

        // Exponential backoff: 2s, 4s, 8s
        final delay =
            Duration(seconds: baseDelay.inSeconds * (1 << (attempt - 1)));
        Logger.info('Retrying in ${delay.inSeconds} seconds...', tag: tag);
        await Future.delayed(delay);
      }
    }
    return null;
  }

  String? get savedFcmToken;
  Future<void> saveFcmToken(String? newToken);

  // 앱 종료된 후 notification 클릭했을 때 처리
  static Future<RemoteMessage?> getInitFcmMsg() async =>
      await FirebaseMessaging.instance.getInitialMessage();
}

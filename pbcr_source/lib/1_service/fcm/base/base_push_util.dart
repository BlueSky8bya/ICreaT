import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:icreat_dct/6_util/logger.dart';

import 'base_push_data.dart';

abstract class BasePushUtil {
  final tag = 'PushMsg';

  /// 앱 실행된 상태에서 푸시메세지 클릭했을 때 처리
  void onClick({String? notiPayload, RemoteMessage? fcmMsg});

  BasePushData? getPushData(String? notiPayload, RemoteMessage? fcmMsg) {
    var pushData = getPushDataFromNotiPayload(notiPayload);
    if (pushData == null && fcmMsg != null) {
      pushData = getPushDataFromFcmMsg(fcmMsg);
    }

    return pushData;
  }

  BasePushData? getPushDataFromNotiPayload(String? notiPayload) {
    if (notiPayload != null) {
      try {
        var data = jsonDecode(notiPayload);
        Logger.info('payload = $notiPayload, data = $data');

        final extraData = data[BasePushData.pushDataExtraDataKey];
        final name = data[BasePushData.pushDataNameKey];
        final pushType = data[BasePushData.pushDataPushTypeKey];

        if (extraData != null) {
          return parseNotiPayload(extraData, name, pushType);
        } else {
          return null;
        }
      } catch (e, s) {
        Logger.error('', e: e, s: s, tag: tag);
        return null;
      }
    } else {
      return null;
    }
  }

  BasePushData? parseNotiPayload(
    String extraData,
    String? name,
    String? pushType,
  );

  BasePushData? getPushDataFromFcmMsg(RemoteMessage fcmMsg) {
    var fcmTypeStr = fcmMsg.data[BasePushData.fcmPushTypeKey] ?? '';

    final title = fcmMsg.notification?.title;
    final body = fcmMsg.notification?.body;
    final image = fcmMsg.notification?.android?.imageUrl;

    try {
      return parseFcmMsg(fcmMsg.data, fcmTypeStr, title, body, image);
    } catch (e, s) {
      Logger.error('FCM push type parse error', e: e, s: s, tag: tag);
      return makeDefaultPushData(fcmTypeStr, title, body, image);
    }
  }

  BasePushData parseFcmMsg(
    Map<String, dynamic> data,
    String fcmTypeStr,
    String? title,
    String? body,
    String? image,
  );

  BasePushData makeDefaultPushData(
    String fcmTypeStr,
    String? title,
    String? body,
    String? image,
  );
}

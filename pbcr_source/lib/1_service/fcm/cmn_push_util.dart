import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:icreat_dct/1_service/fcm/base/base_push_data.dart';
import 'package:icreat_dct/1_service/fcm/base/base_push_util.dart';
import 'package:icreat_dct/1_service/fcm/data/default_push_data.dart';

class CMNPushUtil extends BasePushUtil {
  static void Function(BasePushData)? onMovePage;

  @override
  void onClick({String? notiPayload, RemoteMessage? fcmMsg}) async {}

  // NotificationUtil을 통해 발생시킨 noti를 클릭했을 때 파싱
  @override
  BasePushData? parseNotiPayload(
    String extraData,
    String? name,
    String? pushType,
  ) {
    return null;
  }

  // Fcm의 데이터를 파싱 FCM의 데이터는 모두 String이기 때문에 fromJson을 쓰지 않고 있다.
  @override
  BasePushData parseFcmMsg(
    Map<String, dynamic> data,
    String fcmTypeStr,
    String? title,
    String? body,
    String? image,
  ) {
    return DefaultPushData(
      title: title,
      body: body,
    )..fcmTypeStr = fcmTypeStr;
  }

  @override
  BasePushData makeDefaultPushData(
    String fcmTypeStr,
    String? title,
    String? body,
    String? image,
  ) =>
      DefaultPushData(title: title, body: body)..fcmTypeStr = fcmTypeStr;
}

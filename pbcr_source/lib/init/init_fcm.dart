import 'package:get/get.dart';
import 'package:icreat_dct/1_service/fcm/cmn_fcm_service.dart';
import 'package:icreat_dct/1_service/fcm/cmn_notification_util.dart';
import 'package:icreat_dct/1_service/fcm/cmn_push_util.dart';
import 'package:icreat_dct/6_util/device_info.dart';

/// FCM 초기화
/// Repository 초기화 후 호출 필요
Future<void> initFcm() async {
  final pushUtil = CMNPushUtil();
  Get.put(pushUtil, permanent: true);

  final notificationUtil = CMNNotificationUtil(pushUtil: pushUtil);
  await notificationUtil.initialize();
  if (DeviceInfo.isAndroid) {
    await notificationUtil.requestPermissionAndroid();
  }
  Get.put(notificationUtil, permanent: true);
  final fcmService = CMNFcmService(
    prefHelper: Get.find(),
    deviceInfo: Get.find(),
    notificationUtil: notificationUtil,
    pushUtil: pushUtil,
    authRepository: Get.find(),
  );
  await fcmService.init();

  Get.put(fcmService, permanent: true);
}

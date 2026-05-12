import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/1_service/auth_service.dart';
import 'package:icreat_dct/1_service/ble_service.dart';
import 'package:icreat_dct/1_service/common/fgbg_service.dart';
import 'package:icreat_dct/1_service/crf_service.dart';
import 'package:icreat_dct/1_service/esource_service.dart';
import 'package:icreat_dct/1_service/fcm_device_service.dart';
import 'package:icreat_dct/1_service/health_service.dart';
import 'package:icreat_dct/1_service/local_notification_service.dart';
import 'package:icreat_dct/1_service/measurement_service.dart';
import 'package:icreat_dct/1_service/notification_service.dart';
import 'package:icreat_dct/1_service/permission_service.dart';
import 'package:icreat_dct/1_service/project_service.dart';
import 'package:icreat_dct/1_service/schedule_service.dart';
import 'package:icreat_dct/2_repository/auth_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/6_util/device_info.dart';

void initServices() {
  Get.lazyPut(() => FgBgService());
  Get.lazyPut(() => HealthService(Get.find(),Get.find(),Get.find()));
  Get.lazyPut(() => BleService(Get.find()));
  Get.lazyPut(() => PermissionService());
  Get.lazyPut(() => AuthService(Get.find(), Get.find()));
  Get.lazyPut(() => CRFService(Get.find()));
  Get.lazyPut(() => ProjectService(Get.find(), Get.find()));
  Get.lazyPut(() => ScheduleService(Get.find(), Get.find()));
  Get.lazyPut(() => MeasurementService());
  Get.lazyPut(() => NotificationService(Get.find(), Get.find()));
  Get.lazyPut(() => LocalNotificationService(FlutterLocalNotificationsPlugin(),Get.find()));
  Get.lazyPut(() => EsourceService(Get.find(), Get.find()));

  // Create FCMDeviceService with proper Dio instance
  Get.lazyPut(() => FCMDeviceService(
        Get.find<AuthRepository>(),
        Get.find<DeviceInfo>(),
        Get.find<PrefRepository>(),
      ));
}

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/7_helper/permission_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> initHelpers() async {
  Get.lazyPut(() => PermissionHelper());
  final packageInfo = await PackageInfo.fromPlatform();
  final deviceInfo = DeviceInfo(packageInfo: packageInfo);

  // Initialize device info with platform-specific data
  final deviceInfoPlugin = DeviceInfoPlugin();
  await deviceInfo.init(deviceInfoPlugin);

  Get.lazyPut(() => deviceInfo);
}

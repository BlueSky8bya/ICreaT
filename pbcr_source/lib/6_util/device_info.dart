import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  DeviceInfo({
    required PackageInfo packageInfo,
  })  : versionCode = int.parse(packageInfo.buildNumber),
        versionName = packageInfo.version,
        packageName = packageInfo.packageName;

  final int versionCode;
  final String versionName;
  final String packageName;

  static bool? _isIOS;
  static bool get isIOS {
    _isIOS ??= Platform.isIOS;
    return _isIOS!;
  }

  static bool? _isAndroid;
  static bool get isAndroid {
    _isAndroid ??= Platform.isAndroid;
    return _isAndroid!;
  }

  late final String? iosVersion;
  late final int? androidVersion;
  late final String deviceModel;
  late final String deviceId;

  Future<void> init(DeviceInfoPlugin deviceInfo) async {
    if (isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      iosVersion = iosInfo.systemVersion;
      androidVersion = null;
      deviceId = iosInfo.identifierForVendor ?? 'no device id'; //UUID for iOS
      deviceModel = iosInfo.utsname.machine.iOSProductName;
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      iosVersion = null;
      androidVersion = androidInfo.version.sdkInt;
      deviceId = androidInfo.id;
      deviceModel = androidInfo.model;
    }
  }

  String get osVersion {
    if (isIOS) {
      return iosVersion ?? 'Unknown';
    } else {
      return androidVersion?.toString() ?? 'Unknown';
    }
  }
}

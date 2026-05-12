import 'package:flutter/material.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  String getLabel(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return '카메라';
      case Permission.activityRecognition:
        return '신체 활동';
      case Permission.notification:
        return '알림';
      default:
        return permission.toString().split('.').last;
    }
  }

  /*

  /// return 권한 있으면 true 없으면 false
  Future<bool> requestActivityRecognition(BuildContext context) async {
    final status = await Permission.activityRecognition.request();

    if (status.isGranted) {
      return true;
    } else {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('신체 활동 권한이 필요합니다.'),
          action: SnackBarAction(
            label: '설정',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }

    return false;
  }

  Future<bool> checkActivityRecognitionPermission() async {
    final status = await Permission.activityRecognition.status;
    return status.isGranted;
  }

  /// return 권한 있으면 true 없으면 false
  Future<bool> requestNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      return true;
    } else {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('알림 권한이 필요합니다.'),
          action: SnackBarAction(
            label: '설정',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }

    return false;
  }

  */

  Future<bool> showRequestSnackbar(
      List<Permission> permissions, BuildContext context) async {
    final statuses = await permissions.request();

    final notGrantedPermissions = statuses.entries
        .where((entry) => !entry.value.isGranted)
        .map((e) => e.key)
        .toList();

    if (notGrantedPermissions.isNotEmpty) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${notGrantedPermissions.map((permission) => getLabel(permission)).join(', ')} 권한이 필요합니다.'),
          action: SnackBarAction(
            label: '설정',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }

    return statuses.values.every((status) => status.isGranted);
  }

  Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<bool> requestRequiredPermissions(
    BuildContext context,
  ) async {
    return showRequestSnackbar(
      [
        if (DeviceInfo.isAndroid) Permission.activityRecognition,
        Permission.notification,
      ],
      context,
    );
  }

  Future<bool> requestBluetoothRequirements(BuildContext context) async {
    return showRequestSnackbar(
      DeviceInfo.isAndroid
          ? [
              Permission.location,
              Permission.bluetooth,
              Permission.bluetoothConnect,
              Permission.bluetoothScan
            ]
          : [
              Permission.bluetooth,
            ],
      context,
    );
  }

  Future<bool> checkCameraPermission() async {
    //  final status =  await Permission.camera.request();
    final status = await Permission.camera.status;
    Logger.debug('checkCameraPermission: $status');
    return status.isGranted || status.isLimited;
  }

  Future<bool> requestCameraPermission(BuildContext context) async {
    return showRequestSnackbar(
      [Permission.camera],
      context,
    );
  }
}

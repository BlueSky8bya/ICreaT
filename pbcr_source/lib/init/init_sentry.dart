import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/build_config.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> initSentry(
    DeviceInfo deviceInfo, PrefRepository prefHelper) async {
  await Sentry.init((options) {
    options.dsn =
        'https://947dae4f0e387982a5e75fa674339e2f@o457587.ingest.us.sentry.io/4509704432910336';
    options.environment = BuildConfig.buildVariant;
  });

  var os = '';
  var osVersion = '';

  if (DeviceInfo.isAndroid) {
    os = 'Android';
    osVersion = deviceInfo.androidVersion.toString();
  } else if (DeviceInfo.isIOS) {
    os = 'iOS';
    osVersion = deviceInfo.iosVersion ?? '';
  }

  Sentry.configureScope((scope) {
    scope.setTag("os", os);
    scope.setTag("osVersion", osVersion);
    scope.setTag("deviceModel", deviceInfo.deviceModel);
    scope.setTag("deviceId", deviceInfo.deviceId);
    scope.setTag("appVersionCode", deviceInfo.versionCode.toString());
    scope.setTag("appVersionName", deviceInfo.versionName);
    if (prefHelper.projectId?.isNotEmpty ?? false) {
      scope.setTag("projectId", prefHelper.projectId!);
    }
    if (prefHelper.subjectId?.isNotEmpty ?? false) {
      scope.setTag("subjectId", prefHelper.subjectId!);
    }
  });

  Logger.sendExceptionToSentry = (msg, errorType, e, s) async {
    if (e != null) {
      await Sentry.captureException(e, stackTrace: s);
    } else {
      await Sentry.captureException(msg, stackTrace: s);
    }
  };
}

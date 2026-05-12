import 'package:get/get.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/init/init_channels.dart';
import 'package:icreat_dct/init/init_fcm.dart';
import 'package:icreat_dct/init/init_helpers.dart';
import 'package:icreat_dct/init/init_repositories.dart';
import 'package:icreat_dct/init/init_sentry.dart';
import 'package:icreat_dct/init/init_services.dart';
import 'package:icreat_dct/init/init_view_models.dart';

class Initialize {
  static Future<void> initialize() async {
    await initializeChannels();
    await initializeHelpers();
    await initializeRepositories();
    await initializeServices();
    await initializeViewModels();
    await initializeFcm();
    await initializeSentry();
  }

  static Future<void> initializeServices() async {
    initServices();
  }

  static Future<void> initializeViewModels() async {
    initViewModels();
  }

  static Future<void> initializeRepositories() async {
    await initRepositories();
  }

  static Future<void> initializeHelpers() async {
    await initHelpers();
  }

  static Future<void> initializeChannels() async {
    initChannels();
  }

  static Future<void> initializeFcm() async {
    await initFcm();
  }

  static Future<void> initializeSentry() async {
    await initSentry(Get.find<DeviceInfo>(), Get.find<PrefRepository>());
  }
}

import 'package:get/get.dart';
// import 'package:icreat_dct/2_repository/apple_health_repository.dart';
import 'package:icreat_dct/2_repository/auth_repository.dart';
import 'package:icreat_dct/2_repository/dio_factory.dart';
import 'package:icreat_dct/2_repository/esource_repository.dart';
import 'package:icreat_dct/2_repository/icreat_repository.dart';
import 'package:icreat_dct/2_repository/impl/local_notification_repository_impl.dart';
import 'package:icreat_dct/2_repository/local_notification_repository.dart';
import 'package:icreat_dct/2_repository/notification_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initRepositories() async {
  // Get.lazyPut(() => AppleHealthRepository());
  var prefs = await SharedPreferences.getInstance();
  Get.lazyPut(() => PrefRepository(prefs));

  final dioForAuth = DioFactory.getDioClientForAuth();
  Get.lazyPut(() => AuthRepository(dioForAuth));

  final dioForApi = DioFactory.getDioClientForApi();
  Get.lazyPut(() => IcreatRepository(dioForApi));

  final dioForNotification = DioFactory.getDioClientForApi();
  Get.lazyPut(() => NotificationRepository(dioForNotification));

  Get.lazyPut<LocalNotificationRepository>(() => LocalNotificationRepositoryImpl());

  final dioForEsource = DioFactory.getDioClientForEsource();
  Get.lazyPut(() => EsourceRepository(dioForEsource));
}

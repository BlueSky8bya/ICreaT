import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/1_service/common/fgbg_service.dart';
import 'package:icreat_dct/4_router/init_router.dart';
import 'package:icreat_dct/4_router/router_manager.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/init/initialize.dart';
import 'package:icreat_dct/theme/theme_data_presets.dart';
import 'package:intl/date_symbol_data_local.dart';


final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Initialize.initialize();

    final FgBgService fgBgService = Get.find();

    GoRouter goRouter = initRouter(rootNavKey);
    RouterManager.initialize(goRouter);

    runApp(FGBGNotifier(
      onEvent: fgBgService.onChangeFGBG,
      child: MyApp(router: goRouter),
    ));
  }, (error, stackTrace) {
    Logger.error(error.toString());
  });
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ko_KR', null);
    return GetMaterialApp.router(
      title: 'iCReaT DCT Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeDataPresets.lightTheme,
      darkTheme: ThemeDataPresets.darkTheme,
      themeMode: ThemeMode.light,
      locale: const Locale('ko', 'KR'),
      routerDelegate: router.routerDelegate,
      backButtonDispatcher: router.backButtonDispatcher,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/splash/splash_view_model.dart';

class SplashView extends GetView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      backgroundColor: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/logo.png',
          width: MediaQuery.of(context).size.width * 0.4, // 화면 너비의 40%
        ),
      ),
    );
  }
}

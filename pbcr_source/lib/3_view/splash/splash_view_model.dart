import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/1_service/secure_storage_service.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

enum SplashState {
  initial,
  loading,
  ready,
}

class SplashViewModel extends BaseViewModel {
  final BuildContext _context;

  SplashViewModel(
    this._context,
  );

  final Rx<SplashState> _state = SplashState.initial.obs;

  SplashState get state => _state.value;
  bool get isReady => _state.value == SplashState.ready;

  static const Duration _defaultLoadingDuration = Duration(seconds: 1);

  @override
  void onInit() {
    super.onInit();

    _setState(SplashState.loading);

    Future.wait([
      _waitForMinimumLoading(),
      SecureStorageService().clear(),
      _systemCheck(),
    ]).then((_) {
      _setState(SplashState.ready);
      if (_context.mounted) {
        CommonNavigator.toLogin(_context);
      }
    });
  }

  Future<void> _waitForMinimumLoading() async {
    await Future.delayed(_defaultLoadingDuration);
  }

  void _setState(SplashState newState) {
    _state.value = newState;
  }

  Future<void> _systemCheck() async {
    // TODO: system check if needed
  }
}

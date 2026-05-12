import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/toast/custom_toast.dart';
import 'package:icreat_dct/3_view/components/toast/toast_positions_type.dart';
import 'package:icreat_dct/3_view/components/toast/toast_type.dart';
import 'package:icreat_dct/6_util/logger.dart';

class BaseViewModel extends FullLifeCycleController with FullLifeCycleMixin {
  final RxBool isOnProgress = false.obs;
  final RxBool completedInit = false.obs;

  @override
  void onInit() {
    Logger.info('onInit', tag: '$runtimeType');
    super.onInit();
  }

  @override
  void onClose() {
    Logger.info('onClose', tag: '$runtimeType');
    super.onClose();
  }

  @override
  void onDetached() {
    Logger.info('onDetached', tag: '$runtimeType');
  }

  @override
  void onInactive() {
    Logger.info('onInactive', tag: '$runtimeType');
  }

  @override
  void onPaused() {
    Logger.info('onPaused', tag: '$runtimeType');
  }

  @override
  void onResumed() async {
    Logger.info('onResumed', tag: '$runtimeType');
  }

  @override
  void onHidden() async {
    Logger.info('onHidden', tag: '$runtimeType');
  }

  void showProgress() {
    isOnProgress.value = true;
  }

  void dismissProgress() {
    isOnProgress.value = false;
  }

  void completeInit() {
    completedInit.value = true;
  }

  void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void showToast(
    BuildContext context, {
    ToastType type = ToastType.info,
    required String msg,
    ToastPositionType positionType = ToastPositionType.top,
  }) {
    CustomToast.showToast(
      context,
      type: type,
      msg: msg,
      positionType: positionType,
    );
  }
}

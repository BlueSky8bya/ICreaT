import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icreat_dct/3_view/components/toast/toast_positions_type.dart';
import 'package:icreat_dct/3_view/components/toast/toast_type.dart';
import 'package:icreat_dct/3_view/components/toast/toast_widget.dart';
import 'package:icreat_dct/6_util/toast_util.dart';

class CustomToast {
  static void showToast(
    BuildContext context, {
    required ToastType type,
    required String msg,
    TextStyle? msgTextStyle,
    int? seconds,
    double? top,
    double? left,
    double? right,
    double? bottom,
    ToastPositionType positionType = ToastPositionType.top,
    Widget Function(BuildContext, Widget, ToastGravity?)? positionedToastBuilder,
  }) {
    if (top == null && positionType.isTop) top = 50;
    if (bottom == null && positionType.isBottom) bottom = 50;
    ToastUtil.showCustomToast(
      context: context,
      widget: ToastWidget(
        type: type,
        message: msg,
        msgTextStyle: msgTextStyle,
      ),
      positionedToastBuilder: positionedToastBuilder ??
          (context, child, gravity) => Positioned(
                top: top,
                left: left ?? 24,
                right: right ?? 24,
                bottom: bottom,
                child: child,
              ),
      seconds: seconds ?? 3,
    );
  }

  /// RouterService.context 동작 안함, RouterService.context를 꼭 사용해야 할 경우 SnackBar로 표시
  static void showInfoToast(
    BuildContext context, {
    required String msg,
    ToastPositionType position = ToastPositionType.top,
    TextStyle? msgTextStyle,
    int? seconds,
    double? top,
    double? left,
    double? right,
    double? bottom,
    ToastPositionType positionType = ToastPositionType.top,
  }) {
    showToast(
      context,
      type: ToastType.info,
      msg: msg,
      msgTextStyle: msgTextStyle,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      seconds: seconds,
      positionType: positionType,
    );
  }

  /// RouterService.context 동작 안함, RouterService.context를 꼭 사용해야 할 경우 SnackBar로 표시
  static void showSuccessToast(
    BuildContext context, {
    required String msg,
    TextStyle? msgTextStyle,
    int? seconds,
    double? top,
    double? left,
    double? right,
    double? bottom,
    ToastPositionType positionType = ToastPositionType.top,
  }) {
    showToast(
      context,
      type: ToastType.success,
      msg: msg,
      msgTextStyle: msgTextStyle,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      seconds: seconds,
      positionType: positionType,
    );
  }

  /// RouterService.context 동작 안함, RouterService.context를 꼭 사용해야 할 경우 SnackBar로 표시
  static void showErrorToast(
    BuildContext context, {
    required String msg,
    TextStyle? msgTextStyle,
    int? seconds,
    double? top,
    double? left,
    double? right,
    double? bottom,
    ToastPositionType positionType = ToastPositionType.top,
  }) {
    showToast(
      context,
      type: ToastType.error,
      msg: msg,
      msgTextStyle: msgTextStyle,
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      seconds: seconds,
      positionType: positionType,
    );
  }
}

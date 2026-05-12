import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static final _toast = FToast();
  static Color? background;
  static Color? textColor;

  static void showToast(String msg, {double? fontSize, int seconds = 3}) async {
    await Fluttertoast.cancel();
    await Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: seconds,
      backgroundColor: background,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  /// Get.context 사용 불가
  /// CustomToast
  static void showCustomToast({
    required BuildContext context,
    required Widget widget,
    int seconds = 3,
    Widget Function(BuildContext, Widget, ToastGravity?)? positionedToastBuilder,
  }) async {
    closeCustomToast();
    _toast.init(context);

    _toast.showToast(
      child: widget,
      positionedToastBuilder: positionedToastBuilder ?? (context, child, _) => Positioned(top: 50.0, left: 24.0, right: 24.0, child: child),
      toastDuration: Duration(seconds: seconds),
    );
  }

  static void closeCustomToast() => _toast.removeCustomToast();
}

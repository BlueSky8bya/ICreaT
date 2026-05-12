import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongTap,
    this.onDoubleTap,
    this.customBorder,
    this.borderRadius,
    this.splashColor,
    this.isCircle = false,
    this.isRound = false,
    this.isActivate = true,
    this.backgroundColor,
    this.eventName,
    this.eventParams,
    this.elevation = 0,
    this.debounceTime,
  });

  static double defaultBorderRadius = 16;
  static Color? defaultSplashColor;

  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongTap;
  final GestureTapCallback? onDoubleTap;
  final ShapeBorder? customBorder;
  final double? borderRadius;
  final Color? splashColor;
  final Widget child;
  final bool isCircle;
  final bool isRound;
  final bool isActivate;
  final String? eventName;
  final Map<String, Object>? eventParams;
  final Color? backgroundColor;
  final double elevation;
  final int? debounceTime;

  @override
  Widget build(BuildContext context) {
    final shape = customBorder ??
        (isCircle
            ? const CircleBorder()
            : isRound
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      borderRadius ?? defaultBorderRadius,
                    ),
                  )
                : null);

    return Material(
      elevation: elevation,
      color: backgroundColor ?? Colors.transparent,
      shape: shape,
      type: MaterialType.button,
      child: InkWell(
        onDoubleTap: onDoubleTap,
        onLongPress: onLongTap,
        onTap: onTap,
        customBorder: shape,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? defaultBorderRadius),
        splashColor: splashColor ?? defaultSplashColor,
        child: child,
      ),
    );
  }
}

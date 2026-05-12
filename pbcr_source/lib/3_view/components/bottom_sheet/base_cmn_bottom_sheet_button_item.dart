import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/base/button_color_set.dart';

class BaseCMNBottomSheetButtonItem {
  final String text;
  final Widget? icon;
  final VoidCallback? onTap;
  final ButtonColorSet colorSet;
  final double? borderRadius;

  const BaseCMNBottomSheetButtonItem({
    required this.text,
    this.icon,
    this.onTap,
    this.colorSet = ButtonColorSet.tertiary,
    this.borderRadius,
  });

  factory BaseCMNBottomSheetButtonItem.confirm({
    required VoidCallback? onTap,
  }) {
    return BaseCMNBottomSheetButtonItem(
      text: '확인',
      colorSet: ButtonColorSet.primary,
      onTap: onTap,
    );
  }

  BaseCMNBottomSheetButtonItem copyWith({
    String? text,
    Widget? icon,
    VoidCallback? onTap,
    ButtonColorSet? colorSet,
    double? borderRadius,
  }) {
    return BaseCMNBottomSheetButtonItem(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      colorSet: colorSet ?? this.colorSet,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

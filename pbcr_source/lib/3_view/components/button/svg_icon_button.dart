import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/opacity_widget_button.dart';
import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';

class SvgIconButton extends StatelessWidget {
  final SvgIcons svgIcon;
  final double? size;
  final BoxFit? fit;

  final Color? color;
  final EdgeInsetsGeometry? padding;

  final bool showBadge;

  final int? debounceTime;
  final Function(BuildContext)? onTap;

  const SvgIconButton(
    this.svgIcon, {
    super.key,
    this.size,
    this.fit,
    this.color,
    this.padding,
    this.showBadge = false,
    this.debounceTime,
    this.onTap,
  });

  factory SvgIconButton.noDebounce(
    SvgIcons svgIcon, {
    double? size,
    BoxFit? fit,
    Color? color,
    EdgeInsetsGeometry? padding,
    bool showBadge = false,
    Function(BuildContext)? onTap,
  }) {
    return SvgIconButton(
      svgIcon,
      size: size,
      fit: fit,
      color: color,
      padding: padding,
      showBadge: showBadge,
      debounceTime: 0,
      onTap: onTap,
    );
  }

  // backbutton
  factory SvgIconButton.backButton({
    required Function(BuildContext) onTap,
    Color? color,
    double? size,
    EdgeInsetsGeometry? padding,
    bool showBadge = false,
  }) {
    return SvgIconButton(
      SvgIcons.chevronLeft,
      size: size,
      color: color,
      padding: padding,
      showBadge: showBadge,
      debounceTime: 0,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpacityWidgetButton(
      onTap: onTap,
      debounceTime: debounceTime,
      child: svgIcon.iconBuilder(
        size: size,
        color: color,
        fit: fit,
        padding: padding,
        showBadge: showBadge,
      ),
    );
  }
}

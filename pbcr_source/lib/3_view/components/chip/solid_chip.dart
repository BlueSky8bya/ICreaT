import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/theme/color_hue.dart';

class SolidChip<T> extends StatelessWidget {
  SolidChip({
    super.key,
    this.debounceTime,
    this.isExpanded = false,
    this.data,
    this.onTap,
    required this.text,
    this.textColor,
    this.fontWeight,
    this.color = SolidChipColor.outlineGrey,
    this.size = SolidChipSize.size13,
    this.shape = SolidChipShape.round,
    this.isSelected = false,
    this.withProfile = false,
    this.prefix,
    this.suffix,
    this.onTapSuffix,
    this.padding,
  }) : iconColor = _getIconColor(color, isSelected);

  final int? debounceTime;
  final bool isExpanded;
  final T? data;
  final void Function(T? data)? onTap;
  final dynamic text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final SolidChipColor color;
  final SolidChipSize size;
  final SolidChipShape shape;
  final bool isSelected;
  final bool withProfile;
  final Widget? prefix;
  final Widget? suffix;
  final Function(T? data)? onTapSuffix;
  final EdgeInsetsGeometry? padding;

  final Color iconColor;

  static Color _getIconColor(SolidChipColor color, bool isSelected) {
    switch (color) {
      case SolidChipColor.white:
        return ColorHue.white;
      case SolidChipColor.outlineGrey:
        if (isSelected) return ColorHue.white;
        return ColorHue.gray700;
      case SolidChipColor.grey:
        return ColorHue.gray800;
    }
  }

  SolidButton get chip {
    return SolidButton(
      // debounceTime: debounceTime,
      isExpanded: isExpanded,
      text: text,
      textColor: textColor,
      fontWeight: fontWeight,
      padding: padding ?? size.getPadding(withProfile),
      borderRadius: shape.borderRadius,
      onTap: onTap == null ? null : () => onTap?.call(data),
      leadingIcon: prefix,
      followingIcon: suffix == null
          ? null
          : GestureDetector(
              // debounceTime: 0,
              onTap: onTapSuffix == null ? null : () => onTapSuffix?.call(data),
              child: suffix,
            ),
    );
  }

  SolidChip<T> copyWith({
    int? debounceTime,
    bool? isExpanded,
    dynamic text,
    Color? textColor,
    FontWeight? fontWeight,
    SolidChipColor? color,
    SolidChipSize? size,
    SolidChipShape? shape,
    bool? isSelected,
    T? data,
    void Function(T? data)? onTap,
    bool? withProfile,
    Widget? prefix,
    Widget? suffix,
    void Function(T? data)? onTapSuffix,
    EdgeInsetsGeometry? padding,
  }) {
    return SolidChip(
      debounceTime: debounceTime ?? this.debounceTime,
      isExpanded: isExpanded ?? this.isExpanded,
      text: text ?? this.text,
      textColor: textColor ?? this.textColor,
      fontWeight: fontWeight ?? this.fontWeight,
      color: color ?? this.color,
      size: size ?? this.size,
      shape: shape ?? this.shape,
      isSelected: isSelected ?? this.isSelected,
      data: data ?? this.data,
      onTap: onTap ?? this.onTap,
      withProfile: withProfile ?? this.withProfile,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      onTapSuffix: onTapSuffix ?? this.onTapSuffix,
      padding: padding ?? this.padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case SolidChipColor.outlineGrey:
        if (isSelected) return chip.blackSelectedChip(context);
        return chip.outlineGrey;
      case SolidChipColor.grey:
        if (isSelected) return chip.outlineGreySelectedChip(context);
        return chip.grey;
      case SolidChipColor.white:
        if (isSelected) return chip.outlineWhiteSelectedChip(context);
        return chip.outlineWhite;
    }
  }
}

enum SolidChipColor { outlineGrey, grey, white }

extension SolidChipColorExt on SolidChipColor {
  bool get isOutlineGrey => this == SolidChipColor.outlineGrey;
  bool get isGrey => this == SolidChipColor.grey;
  bool get isWhite => this == SolidChipColor.white;
}

enum SolidChipShape { rect, round }

extension SolidChipShapeExt on SolidChipShape {
  double get borderRadius {
    switch (this) {
      case SolidChipShape.rect:
        return 0;
      case SolidChipShape.round:
        return 100;
    }
  }
}

enum SolidChipSize { size13, size14 }

extension SolidChipSizeExt on SolidChipSize {
  EdgeInsets getPadding(bool withProfile) {
    switch (this) {
      case SolidChipSize.size13:
        if (withProfile) {
          return const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
        }
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

      case SolidChipSize.size14:
        if (withProfile) {
          return const EdgeInsets.symmetric(horizontal: 10, vertical: 7);
        }
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 9);
    }
  }

  double get profileImageSize {
    switch (this) {
      case SolidChipSize.size13:
        return 20;
      case SolidChipSize.size14:
        return 24;
    }
  }

  double get iconSize {
    switch (this) {
      case SolidChipSize.size13:
        return 16;
      case SolidChipSize.size14:
        return 20;
    }
  }
}

extension SolidChipExt on SolidChip {
  SolidChip get outlineGrey => copyWith(color: SolidChipColor.outlineGrey);
  SolidChip get grey => copyWith(color: SolidChipColor.grey);
  SolidChip get white => copyWith(color: SolidChipColor.white);

  SolidChip get rect => copyWith(shape: SolidChipShape.rect);
  SolidChip get round => copyWith(shape: SolidChipShape.round);

  SolidChip get size13 => copyWith(size: SolidChipSize.size13);
  SolidChip get size14 => copyWith(size: SolidChipSize.size14);

  // SolidChip get add => copyWith(
  //       prefix: SizedBox(
  //         width: size.iconSize,
  //         height: size.iconSize,
  //         child: SvgPicture.asset(
  //           NewSvgIconType.plus.svgPath,
  //           colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
  //         ),
  //       ),
  //     );
  // SolidChip get remove => copyWith(
  //       suffix: SizedBox(
  //         width: size.iconSize,
  //         height: size.iconSize,
  //         child: SvgPicture.asset(
  //           NewSvgIconType.cancel.svgPath,
  //           colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
  //         ),
  //       ),
  //     );

  // SolidChip get leadingCheck => copyWith(
  //       prefix: SizedBox(
  //         width: size.iconSize,
  //         height: size.iconSize,
  //         child: SvgPicture.asset(
  //           NewSvgIconType.check.svgPath,
  //           colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
  //         ),
  //       ),
  //     );

  // SolidChip get check {
  //   var icon = SizedBox(
  //     width: size.iconSize,
  //     height: size.iconSize,
  //     child: SvgPicture.asset(
  //       NewSvgIconType.check.svgPath,
  //       colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
  //     ),
  //   );
  //   if (isSelected && color.isOutlineGrey) {
  //     icon = SizedBox(
  //       width: size.iconSize,
  //       height: size.iconSize,
  //       child: SvgPicture.asset(
  //         NewSvgIconType.checkRoundFilled.svgPath,
  //       ),
  //     );
  //   }
  //   return copyWith(suffix: icon);
  // }
}

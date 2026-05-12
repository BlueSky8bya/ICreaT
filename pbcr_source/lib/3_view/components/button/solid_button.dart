import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/base/base_button.dart';
import 'package:icreat_dct/3_view/components/button/base/base_button_size.dart';
import 'package:icreat_dct/3_view/components/button/base/button_color_set.dart';
import 'package:icreat_dct/8_extension/list_ext.dart';
import 'package:icreat_dct/theme/color_hue.dart';
import 'package:icreat_dct/theme/text_styles.dart';

// 일반
// 호버링, 클릭
// 비활성화
class SolidButton extends StatelessWidget {
  const SolidButton({
    super.key,
    this.throttleTime,
    this.text,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.followingIcon,
    this.leadingIcon,
    this.iconSpacing,
    this.padding,
    this.minHeight,
    this.minWidth,
    this.borderRadius,
    this.color,
    this.highlightColor,
    this.borderColor,
    this.highlightBorderColor,
    this.disabledOpacity,
    this.isOutline = false,
    this.isExpanded = false,
    this.onTap,
  });

  final int? throttleTime;
  final dynamic text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  final double? iconSpacing;

  /// 오른쪽에 위치할 아이콘
  final Widget? followingIcon;

  /// 왼쪽에 위치할 아이콘
  final Widget? leadingIcon;

  final EdgeInsetsGeometry? padding;

  /// 버튼의 최소 높이
  final double? minHeight;

  /// 버튼의 최소 너비
  final double? minWidth;

  final double? borderRadius;

  /// 배경 색상
  final Color? color;

  /// 스플래시 색상
  final Color? highlightColor;

  /// 테두리 색상
  final Color? borderColor;

  /// 스플래시 테두리 색상
  final Color? highlightBorderColor;

  /// disabledColor 대신 사용될 때 투명도 없으면 0.3이 적용된다.
  final double? disabledOpacity;

  final bool isOutline;

  final bool isExpanded;

  final VoidCallback? onTap;

  static const _defaultIconSpacing = 4.0;

  Color _color(BuildContext context) =>
      color ?? ButtonColorSet.primary.color(context);
  Color _highlightColor(BuildContext context) =>
      highlightColor ?? ButtonColorSet.primary.highlightColor(context);
  Color _borderColor(BuildContext context) =>
      borderColor ?? ButtonColorSet.primary.borderColor(context);
  Color _highlightBorderColor(BuildContext context) =>
      highlightBorderColor ??
      ButtonColorSet.primary.highlightBorderColor(context);

  bool get isDisabled => onTap == null;

  Widget _buildCenter() {
    Widget child;

    if (text is Widget) {
      child = text;
    } else if (text is String) {
      child = Text.rich(
        TextSpan(
          children: [
            if (leadingIcon != null)
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle, child: leadingIcon!),
            TextSpan(text: text),
            if (followingIcon != null)
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: followingIcon!),
          ].insertBetween(
            WidgetSpan(
              child: SizedBox(width: iconSpacing ?? _defaultIconSpacing),
            ),
          ),
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: Fonts.pretendard,
          fontSize: fontSize ?? BaseButtonSize.small.textStyle.fontSize,
          fontWeight: fontWeight ?? BaseButtonSize.small.textStyle.fontWeight,
          color: textColor ?? ColorHue.white,
        ),
      );
    } else {
      child = const SizedBox.shrink();
    }

    return isExpanded ? Expanded(child: child) : child;
  }

  // text가 String이 아닌경우 아래 build()에서 빌드한다.
  bool get _buildIconAsWidget {
    return text is! String;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minHeight ?? BaseButtonSize.small.minHeight,
        minWidth: minWidth ?? 0,
      ),
      child: BaseButton(
        throttleTime: throttleTime,
        onTap: onTap,
        color: _color(context),
        highlightColor: _highlightColor(context),
        borderColor: _borderColor(context),
        highlightBorderColor: _highlightBorderColor(context),
        borderRadius: borderRadius,
        isOutline: isOutline,
        child: Padding(
          padding: padding ?? BaseButtonSize.small.padding,
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_buildIconAsWidget && leadingIcon != null) leadingIcon!,
              _buildCenter(),
              if (_buildIconAsWidget && followingIcon != null) followingIcon!,
            ].insertBetween(
              SizedBox(width: iconSpacing ?? _defaultIconSpacing),
            ),
          ),
        ),
      ),
    );
  }

  SolidButton copyWith({
    int? throttleTime,
    dynamic text,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    Widget? followingIcon,
    double? followingIconSpacing,
    EdgeInsets? padding,
    double? minHeight,
    double? minWidth,
    double? borderRadius,
    Widget? leadingIcon,
    double? leadingIconSpacing,
    Color? color,
    Color? highlightColor,
    Color? borderColor,
    Color? highlightBorderColor,
    double? disabledOpacity,
    bool? isOutline,
    bool? isExpanded,
    VoidCallback? onTap,
  }) =>
      SolidButton(
        throttleTime: throttleTime ?? this.throttleTime,
        text: text ?? this.text,
        textColor: textColor ?? this.textColor,
        fontSize: fontSize ?? this.fontSize,
        fontWeight: fontWeight ?? this.fontWeight,
        followingIcon: followingIcon ?? this.followingIcon,
        iconSpacing: followingIconSpacing ?? iconSpacing,
        padding: padding ?? this.padding,
        minHeight: minHeight ?? this.minHeight,
        minWidth: minWidth ?? this.minWidth,
        borderRadius: borderRadius ?? this.borderRadius,
        leadingIcon: leadingIcon ?? this.leadingIcon,
        color: color ?? this.color,
        highlightColor: highlightColor ?? this.highlightColor,
        borderColor: borderColor ?? this.borderColor,
        highlightBorderColor: highlightBorderColor ?? this.highlightBorderColor,
        disabledOpacity: disabledOpacity ?? this.disabledOpacity,
        isOutline: isOutline ?? this.isOutline,
        isExpanded: isExpanded ?? this.isExpanded,
        onTap: onTap ?? this.onTap,
      );
}

extension SolidButtonExt on SolidButton {
  // ------------------------------ Color ------------------------------
  SolidButton fromColorSet(BuildContext context, ButtonColorSet colorSet) {
    switch (colorSet) {
      case ButtonColorSet.primary:
        return primary(context);
      case ButtonColorSet.secondary:
        return secondary(context);
      case ButtonColorSet.tertiary:
        return tertiary(context);
      case ButtonColorSet.error:
        return error(context);
      case ButtonColorSet.outline:
        return outline(context);
    }
  }

  SolidButton primary(BuildContext context) => copyWith(
        textColor: ButtonColorSet.primary.textColor(context),
        color: ButtonColorSet.primary.color(context),
        highlightColor: ButtonColorSet.primary.highlightColor(context),
      );

  SolidButton secondary(BuildContext context) => copyWith(
        textColor: ButtonColorSet.secondary.textColor(context),
        color: ButtonColorSet.secondary.color(context),
        highlightColor: ButtonColorSet.secondary.highlightColor(context),
      );

  SolidButton tertiary(BuildContext context) => copyWith(
        textColor: ButtonColorSet.tertiary.textColor(context),
        color: ButtonColorSet.tertiary.color(context),
        highlightColor: ButtonColorSet.tertiary.highlightColor(context),
      );

  SolidButton error(BuildContext context) => copyWith(
        textColor: ButtonColorSet.error.textColor(context),
        color: ButtonColorSet.error.color(context),
        highlightColor: ButtonColorSet.error.highlightColor(context),
      );

  SolidButton outline(BuildContext context) => copyWith(
        isOutline: true,
        textColor: ButtonColorSet.outline.textColor(context),
        color: ButtonColorSet.outline.color(context),
        highlightColor: ButtonColorSet.outline.highlightColor(context),
        borderColor: ButtonColorSet.outline.borderColor(context),
        highlightBorderColor:
            ButtonColorSet.outline.highlightBorderColor(context),
      );

  SolidButton get outlineWhite => copyWith(
        isOutline: true,
        textColor: ColorHue.white,
        color: ColorHue.white,
        highlightColor: ColorHue.white.withValues(alpha: 0.2),
      );

  SolidButton rRectangle({
    required double borderRadius,
  }) =>
      copyWith(
        fontSize: BaseButtonSize.small.textStyle.fontSize,
        fontWeight: BaseButtonSize.small.textStyle.fontWeight,
        padding: BaseButtonSize.small.padding,
        borderRadius: borderRadius,
      );

  SolidButton get circle => copyWith(
        borderRadius: 10000,
      );

  SolidButton customSize({
    double? fontSize,
    FontWeight? fontWeight,
    EdgeInsets? padding,
  }) =>
      copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        padding: padding,
      );

  SolidButton get small {
    return copyWith(
      fontSize: BaseButtonSize.small.textStyle.fontSize,
      fontWeight: BaseButtonSize.small.textStyle.fontWeight,
      padding: BaseButtonSize.small.padding,
      minHeight: BaseButtonSize.small.minHeight,
    );
  }

  SolidButton get medium {
    return copyWith(
      fontSize: BaseButtonSize.medium.textStyle.fontSize,
      fontWeight: BaseButtonSize.medium.textStyle.fontWeight,
      padding: BaseButtonSize.medium.padding,
      minHeight: BaseButtonSize.medium.minHeight,
    );
  }

  SolidButton get large {
    return copyWith(
      fontSize: BaseButtonSize.large.textStyle.fontSize,
      fontWeight: BaseButtonSize.large.textStyle.fontWeight,
      padding: BaseButtonSize.large.padding,
      minHeight: BaseButtonSize.large.minHeight,
    );
  }

  SolidButton get extraLarge {
    return copyWith(
      fontSize: BaseButtonSize.extraLarge.textStyle.fontSize,
      fontWeight: BaseButtonSize.extraLarge.textStyle.fontWeight,
      padding: BaseButtonSize.extraLarge.padding,
      minHeight: BaseButtonSize.extraLarge.minHeight,
    );
  }

  SolidButton get expand {
    return copyWith(
      isExpanded: true,
    );
  }

  SolidButton get loose {
    return copyWith(
      isExpanded: false,
    );
  }

  SolidButton get textAreaEnter {
    return medium.copyWith(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 4,
    );
  }
}

extension SolidButtonChips on SolidButton {
  SolidButton outlineGreySelectedChip(BuildContext context) => copyWith(
        textColor: ColorHue.gray800,
        color: ColorHue.gray200,
        highlightColor: ColorHue.gray200,
        highlightBorderColor: ColorHue.gray200,
      );

  SolidButton get outlineGrey => copyWith(
        isOutline: true,
        textColor: ColorHue.gray800,
        color: ColorHue.transparent,
        highlightColor: ColorHue.gray200,
        borderColor: ColorHue.gray200,
        highlightBorderColor: ColorHue.gray200,
      );

  SolidButton get grey => copyWith(
        textColor: ColorHue.gray800,
        color: ColorHue.gray200,
        highlightColor: ColorHue.gray200,
      );

  SolidButton blackSelectedChip(BuildContext context) => copyWith(
        textColor: ColorHue.white,
        color: ColorHue.gray800,
        highlightColor: ColorHue.gray900,
      );

  SolidButton outlineWhiteSelectedChip(BuildContext context) => copyWith(
        textColor: ColorHue.white,
        color: ColorHue.white.withValues(alpha: 0.2),
        highlightColor: ColorHue.gray900,
      );
}

import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

extension TextStyleExt on TextStyle {
  TextStyle fromColor(Color? color) => copyWith(color: color);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.normal);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  TextStyle primaryColor(BuildContext context) {
    return copyWith(
      color: context.textPrimary,
    );
  }

  TextStyle secondaryColor(BuildContext context) {
    return copyWith(
      color: context.textSecondary,
    );
  }

  TextStyle secondaryHoverPressedColor(BuildContext context) {
    return copyWith(
      color: context.textSecondaryHoverPressed,
    );
  }

  TextStyle tertiaryColor(BuildContext context) {
    return copyWith(
      color: context.textTertiary,
    );
  }

  TextStyle inverseColor(BuildContext context) {
    return copyWith(
      color: context.textInverse,
    );
  }

  TextStyle brandColor(BuildContext context) {
    return copyWith(
      color: context.textBrand,
    );
  }

  TextStyle dangerColor(BuildContext context) {
    return copyWith(
      color: context.textDanger,
    );
  }

  TextStyle successColor(BuildContext context) {
    return copyWith(
      color: context.textSuccess,
    );
  }

  TextStyle warningColor(BuildContext context) {
    return copyWith(
      color: context.textWarning,
    );
  }

  TextStyle disabledColor(BuildContext context) {
    return copyWith(
      color: context.textDisabled,
    );
  }

  TextStyle infoColor(BuildContext context) {
    return copyWith(
      color: context.textInfo,
    );
  }

  TextStyle calendarTextColor(BuildContext context) {
    return copyWith(
      color: context.calendarText,
    );
  }
}

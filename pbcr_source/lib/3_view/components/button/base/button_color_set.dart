import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

enum ButtonColorSet {
  primary,
  secondary,
  tertiary,
  outline,
  error,
}

extension BaseButtonColorSetExt on ButtonColorSet {
  /// default color
  Color color(BuildContext context) {
    switch (this) {
      case ButtonColorSet.primary:
        return context.bgBrand;
      case ButtonColorSet.secondary:
        return context.bgSecondary;
      case ButtonColorSet.tertiary:
        return context.bgTertiary;
      case ButtonColorSet.outline:
        return context.bgPrimary;
      case ButtonColorSet.error:
        return context.bgDanger;
    }
  }

  /// hover & pressed color
  Color highlightColor(BuildContext context) {
    switch (this) {
      case ButtonColorSet.primary:
        return context.bgBrandHoverPressed;
      case ButtonColorSet.secondary:
        return context.bgSecondaryHoverPressed;
      case ButtonColorSet.tertiary:
        return context.bgTertiaryHoverPressed;
      case ButtonColorSet.outline:
        return context.bgPrimaryHoverPressed;
      case ButtonColorSet.error:
        return context.bgBrandHoverPressed;
    }
  }

  /// border color
  Color borderColor(BuildContext context) {
    switch (this) {
      case ButtonColorSet.primary:
        return context.bgBrand;
      case ButtonColorSet.secondary:
        return context.bgSecondary;
      case ButtonColorSet.tertiary:
        return context.bgTertiary;
      case ButtonColorSet.outline:
        return context.borderPrimary;
      case ButtonColorSet.error:
        return context.bgDanger;
    }
  }

  /// border highlight color
  Color highlightBorderColor(BuildContext context) {
    switch (this) {
      case ButtonColorSet.primary:
        return context.bgBrand;
      case ButtonColorSet.secondary:
        return context.bgSecondary;
      case ButtonColorSet.tertiary:
        return context.bgTertiary;
      case ButtonColorSet.outline:
        return context.borderPrimaryHoverPressed;
      case ButtonColorSet.error:
        return context.bgDanger;
    }
  }

  /// textColor
  Color textColor(BuildContext context) {
    switch (this) {
      case ButtonColorSet.primary:
        return context.textInverse;
      case ButtonColorSet.secondary:
        return context.textPrimary;
      case ButtonColorSet.tertiary:
        return context.textPrimaryHoverPressed;
      case ButtonColorSet.outline:
        return context.textPrimaryHoverPressed;
      case ButtonColorSet.error:
        return context.textInverse;
    }
  }
}

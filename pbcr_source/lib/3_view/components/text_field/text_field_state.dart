import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

enum TextFieldState { default$, focused, filled, disabled, error }

extension TextFieldStateExt on TextFieldState {
  bool get isDefault => this == TextFieldState.default$;
  bool get isFocused => this == TextFieldState.focused;
  bool get isFilled => this == TextFieldState.filled;
  bool get isDisabled => this == TextFieldState.disabled;
  bool get isError => this == TextFieldState.error;
}

extension TextAreaTextState on TextFieldState {
  Color cursorColor(BuildContext context) {
    switch (this) {
      case TextFieldState.error:
        return context.textBrand;
      default:
        return context.textBrand;
    }
  }

  Color backgroundColor(BuildContext context) {
    switch (this) {
      case TextFieldState.default$:
        return context.bgPrimary;
      case TextFieldState.disabled:
        return context.bgDisabled;
      default:
        return context.bgPrimary;
    }
  }

  Border border(BuildContext context) {
    switch (this) {
      case TextFieldState.focused:
        return Border.all(
          color: context.borderPrimaryHoverPressed,
        );
      case TextFieldState.filled:
        return Border.all(
          color: context.borderPrimary,
        );
      case TextFieldState.error:
        return Border.all(
          color: context.borderDanger,
        );
      default:
        return Border.all(
          color: context.borderPrimary,
        );
    }
  }

  TextStyle counterTextStyle(BuildContext context) {
    switch (this) {
      case TextFieldState.default$:
      case TextFieldState.disabled:
      default:
        return TextStyles.caption1.tertiaryColor(context);
    }
  }

  TextStyle textStyle(BuildContext context) {
    switch (this) {
      case TextFieldState.disabled:
        return TextStyles.body2.primaryColor(context);
      default:
        return TextStyles.body2.primaryColor(context);
    }
  }

  double errorOpacity(BuildContext context) {
    switch (this) {
      case TextFieldState.error:
        return 1;
      default:
        return 0;
    }
  }
}

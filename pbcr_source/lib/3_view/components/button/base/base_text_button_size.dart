import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/text_styles.dart';

enum BaseTextButtonSize {
  small,
  medium,
  large,
}

extension BaseTextButtonSizeExt on BaseTextButtonSize {
  EdgeInsets get padding {
    switch (this) {
      case BaseTextButtonSize.small:
        return const EdgeInsets.symmetric(vertical: 3);
      case BaseTextButtonSize.medium:
        return const EdgeInsets.symmetric(vertical: 9);
      case BaseTextButtonSize.large:
        return const EdgeInsets.symmetric(vertical: 11);
    }
  }

  TextStyle get textStyles {
    switch (this) {
      case BaseTextButtonSize.small:
        return TextStyles.caption1;
      case BaseTextButtonSize.medium:
        return TextStyles.body2;
      case BaseTextButtonSize.large:
        return TextStyles.body2;
    }
  }

  double get iconSize {
    switch (this) {
      case BaseTextButtonSize.small:
        return 16;
      case BaseTextButtonSize.medium:
      case BaseTextButtonSize.large:
        return 20;
    }
  }

  double get iconSpacing {
    switch (this) {
      case BaseTextButtonSize.small:
        return 2.0;
      case BaseTextButtonSize.medium:
      case BaseTextButtonSize.large:
        return 4.0;
    }
  }
}

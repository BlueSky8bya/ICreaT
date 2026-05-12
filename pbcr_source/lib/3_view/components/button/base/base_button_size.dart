import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/text_styles.dart';

enum BaseButtonSize {
  tiny,

  /// size 34
  small,

  /// size 36
  medium,

  /// size 40
  large,

  /// size 48
  extraLarge, // 48
}

extension BaseButtonSizeExt on BaseButtonSize {
  double get minHeight {
    switch (this) {
      case BaseButtonSize.tiny:
        return 26;
      case BaseButtonSize.small:
        return 34;
      case BaseButtonSize.medium:
        return 36;
      case BaseButtonSize.large:
        return 40;
      case BaseButtonSize.extraLarge:
        return 48;
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case BaseButtonSize.tiny:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 4);
      case BaseButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case BaseButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case BaseButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case BaseButtonSize.extraLarge:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  TextStyle get textStyle {
    switch (this) {
      case BaseButtonSize.tiny:
        return TextStyles.caption2;
      case BaseButtonSize.small:
        return TextStyles.caption1;
      case BaseButtonSize.medium:
        return TextStyles.body2;
      case BaseButtonSize.large:
        return TextStyles.body2;
      case BaseButtonSize.extraLarge:
        return TextStyles.body1;
    }
  }

  double get iconSize {
    switch (this) {
      case BaseButtonSize.tiny:
        return 16;
      case BaseButtonSize.small:
        return 18;
      case BaseButtonSize.medium:
        return 20;
      case BaseButtonSize.large:
        return 20;
      case BaseButtonSize.extraLarge:
        return 24;
    }
  }
}

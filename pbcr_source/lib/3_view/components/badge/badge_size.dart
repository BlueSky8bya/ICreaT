import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

enum BadgeSize {
  small,
  large,
}

extension BadgeSizeExt on BadgeSize {
  TextStyle textStyle(BuildContext context) {
    switch (this) {
      case BadgeSize.small:
        return TextStyles.caption2.secondaryColor(context);
      case BadgeSize.large:
        return TextStyles.caption1.secondaryColor(context).medium;
    }
  }

  double get iconSize {
    switch (this) {
      case BadgeSize.small:
        return 12;
      case BadgeSize.large:
        return 16;
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case BadgeSize.small:
        return const EdgeInsets.symmetric(
          vertical: 4.5,
          horizontal: 8,
        );
      case BadgeSize.large:
        return const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        );
    }
  }
}

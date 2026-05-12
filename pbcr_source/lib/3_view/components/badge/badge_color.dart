import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

enum BadgeColor {
  grey,
  blue,
  yellow,
  red,
  green,
  orange;

  static BadgeColor fromPreset(String value) {
    switch (value) {
      case 'grey':
        return BadgeColor.grey;
      case 'blue':
        return BadgeColor.blue;
      case 'yellow':
        return BadgeColor.yellow;
      case 'red':
        return BadgeColor.red;
      case 'green':
        return BadgeColor.green;
      case 'orange':
        return BadgeColor.orange;
      default:
        return BadgeColor.grey;
    }
  }
}

extension BadgeColorExt on BadgeColor {
  Color textColor(BuildContext context) {
    switch (this) {
      case BadgeColor.grey:
        return context.textSecondary;
      case BadgeColor.blue:
        return context.textInfo;
      case BadgeColor.yellow:
        return context.textWarning;
      case BadgeColor.red:
        return context.textDanger;
      case BadgeColor.green:
        return context.textSuccess;
      case BadgeColor.orange:
        return context.textWarning;
    }
  }

  Color backgroundColor(BuildContext context) {
    switch (this) {
      case BadgeColor.grey:
        return context.bgTertiary;
      case BadgeColor.blue:
        return context.bgInfoSubtitle;
      case BadgeColor.yellow:
        return context.bgWarningSubtitle;
      case BadgeColor.red:
        return context.bgDangerSubtitle;
      case BadgeColor.green:
        return context.bgSuccessSubtitle;
      case BadgeColor.orange:
        return context.bgWarningSubtitle;
    }
  }

  Color highlighColor(BuildContext context) {
    switch (this) {
      case BadgeColor.grey:
        return context.bgTertiaryHoverPressed;
      case BadgeColor.blue:
        return context.bgInfoSubtitle;
      case BadgeColor.yellow:
        return context.bgWarningSubtitle;
      case BadgeColor.red:
        return context.bgDangerSubtitle;
      case BadgeColor.green:
        return context.bgSuccessSubtitle;
      case BadgeColor.orange:
        return context.bgWarningSubtitle;
    }
  }
}

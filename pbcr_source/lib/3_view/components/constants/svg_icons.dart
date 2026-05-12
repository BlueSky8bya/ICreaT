import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/icon/common_svg_picture.dart';

enum SvgIcons {
  checkRoundFilled,
  infoFilled,
  reportFilled,
  warningFilled,
  cancel,
  calendar,
  chevronLeft,
  chevronRight,
  chevronDown,
  chevronUp,
  arrowRange,
  bloodPressure,
  thermometer,
  weight,
  pencil,
  bluetooth,
}

extension SvgIconsExt on SvgIcons {
  String get svgPath {
    switch (this) {
      case SvgIcons.checkRoundFilled:
        return fullPath('icon_check_round_filled.svg');
      case SvgIcons.infoFilled:
        return fullPath('icon_info_filled.svg');
      case SvgIcons.reportFilled:
        return fullPath('icon_report_filled.svg');
      case SvgIcons.warningFilled:
        return fullPath('icon_warning_filled.svg');
      case SvgIcons.cancel:
        return fullPath('icon_cancel.svg');
      case SvgIcons.calendar:
        return fullPath('icon_calendar.svg');
      case SvgIcons.chevronLeft:
        return fullPath('icon_chevron_left.svg');
      case SvgIcons.chevronRight:
        return fullPath('icon_chevron_right.svg');
      case SvgIcons.chevronDown:
        return fullPath('icon_chevron_down.svg');
      case SvgIcons.chevronUp:
        return fullPath('icon_chevron_up.svg');
      case SvgIcons.arrowRange:
        return fullPath('icon_arrow_range.svg');
      case SvgIcons.bloodPressure:
        return fullPath('icon_blood_pressure.svg');
      case SvgIcons.thermometer:
        return fullPath('icon_thermometer.svg');
      case SvgIcons.weight:
        return fullPath('icon_weight.svg');
      case SvgIcons.pencil:
        return fullPath('icon_pencil.svg');
      case SvgIcons.bluetooth:
        return fullPath('icon_bluetooth.svg');
    }
  }

  String fullPath(String filePath) {
    return 'assets/svgs/icons/$filePath';
  }

  Widget iconBuilder({
    double? size,
    Color? color,
    BoxFit? fit,
    EdgeInsetsGeometry? padding,
    bool showBadge = false,
  }) {
    return CommonSvgPicture(
      svgPath,
      size: size,
      color: color,
      fit: fit,
      padding: padding,
      showBadge: showBadge,
    );
  }
}

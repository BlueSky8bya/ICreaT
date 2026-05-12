import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/calendar/components/calendar_constatns.dart';
import 'package:icreat_dct/3_view/components/calendar/data/day_property.dart';
import 'package:icreat_dct/theme/color_hue.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';

class CalendarStyler {
  /// 날짜에 맞는 텍스트 스타일을 반환합니다.
  /// 오늘인 경우 최우선적으로
  static TextStyle getDateTextStyle(
    BuildContext context,
    DayProperty dayProperty,
  ) {
    final baseStyle = CalendarConstants.smallDayTextStyle;

    if (dayProperty.dayType == DayType.today) {
      return baseStyle.inverseColor(context);
    }

    if (dayProperty.dayType == DayType.outMonth) {
      return baseStyle.disabledColor(context);
    }

    if (dayProperty.date.weekday == DateTime.saturday) {
      return baseStyle.infoColor(context);
    }

    if (dayProperty.date.weekday == DateTime.sunday) {
      return baseStyle.dangerColor(context);
    }

    return baseStyle.primaryColor(context);
  }

  /// 텍스트를 감싸는 박스의 데코레이션을 반환합니다.
  static BoxDecoration? getTextBoxDeco(
    BuildContext context,
    DayProperty dayProperty,
  ) {
    if (dayProperty.dayType == DayType.today) {
      return BoxDecoration(
        color: context.bgInverseBold,
        borderRadius: BorderRadius.circular(100),
      );
    }

    return null;
  }

  /// 타일의 박스 데코레이션을 반환합니다.
  static BoxDecoration? getTileBoxDeco(
    BuildContext context,
    DayProperty dayProperty,
  ) {
    if (dayProperty.selectionType == SelectionType.selected) {
      return BoxDecoration(
        color: context.bgSuccessSubtitle,
        border: Border.all(
          color: context.borderSuccessBold,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      );
    }

    return null;
  }

  static BoxDecoration? getCircleBoxDeco(
    BuildContext context,
    DayProperty dayProperty,
  ) {
    if (dayProperty.selectionType == SelectionType.selected) {
      return BoxDecoration(
        color: ColorHue.gray900,
        shape: BoxShape.circle,
      );
    }

    return null;
  }
}

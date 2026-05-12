import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/opacity_widget_button.dart';
import 'package:icreat_dct/3_view/components/calendar/components/calendar_constatns.dart';
import 'package:icreat_dct/3_view/components/calendar/data/day_property.dart';
import 'package:icreat_dct/3_view/components/calendar/util/calendar_styler.dart';
import 'package:icreat_dct/6_util/text_widget_util.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';

class DefaultDayTile extends StatelessWidget {
  final DayProperty dayProperty;

  final Function(DateTime)? onTap;
  final Function(DateTime)? onDoubleTap;

  const DefaultDayTile({
    super.key,
    required this.dayProperty,
    this.onTap,
    this.onDoubleTap,
  });

  DateTime get day => dayProperty.date;

  TextStyle _textStyle(BuildContext context) {
    final baseStyle = CalendarConstants.mediumDayTextStyle;

    if (dayProperty.dayType == DayType.today) {
      return baseStyle.inverseColor(context);
    }

    if (dayProperty.dayType == DayType.outMonth) {
      return baseStyle.disabledColor(context);
    }

    return baseStyle.primaryColor(context);
  }

  double _circleSize(BuildContext context) {
    return TextWidgetUtil.getTextWidth(
          text: '00',
          style: CalendarConstants.mediumDayTextStyle,
        ) +
        4;
  }

  @override
  Widget build(BuildContext context) {
    return OpacityWidgetButton.noDebounce(
      onTap: (_) => onTap?.call(day),
      onDoubleTap: (_) => onDoubleTap?.call(day),
      useFastDoubleTap: true,
      child: DecoratedBox(
        decoration: CalendarStyler.getTileBoxDeco(context, dayProperty) ??
            const BoxDecoration(),
        child: Container(
          width: double.infinity,
          padding: CalendarConstants.calendarTilePadding,
          child: Center(
            child: _buildDecoDayText(context, day.day.toString()),
          ),
        ),
      ),
    );
  }

  Widget _buildDecoDayText(BuildContext context, String text) {
    final textStyle = _textStyle(context);
    final circleSize = _circleSize(context);

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: CalendarStyler.getTextBoxDeco(context, dayProperty) ??
          const BoxDecoration(),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}

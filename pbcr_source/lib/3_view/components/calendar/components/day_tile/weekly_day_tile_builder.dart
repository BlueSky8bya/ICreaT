import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';
import 'package:icreat_dct/3_view/components/button/opacity_widget_button.dart';
import 'package:icreat_dct/3_view/components/calendar/components/calendar_constatns.dart';
import 'package:icreat_dct/3_view/components/calendar/components/day_tile/day_tile_builder.dart';
import 'package:icreat_dct/3_view/components/calendar/data/day_property.dart';
import 'package:icreat_dct/3_view/components/calendar/util/calendar_styler.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';

class WeeklyDayTileBuilder implements DayTileBuilder {
  final List<ScheduleItemModel> Function(DateTime)? getSchedule;

  const WeeklyDayTileBuilder({this.getSchedule});

  @override
  Widget build(
    BuildContext context,
    DateTime day,
    DateTime? selectedDate,
    DateTime focusedDay, {
    Function(DateTime)? onTap,
    Function(DateTime)? onDoubleTap,
  }) {
    final isSelectedDate = isSameDay(day, selectedDate);
    final dayType = DayType.fromDateTime(day, focusedDay);
    final dayProperty = DayProperty(
      date: day,
      dayType: dayType,
      selectionType:
          isSelectedDate ? SelectionType.selected : SelectionType.none,
    );
    final schedules = getSchedule?.call(day.toLocalize());
    final hasEvent = schedules?.isNotEmpty ?? false;

    return WeeklyDayTile(
      dayProperty: dayProperty,
      onTap: onTap,
      hasEvent: hasEvent,
    );
  }
}

class WeeklyDayTile extends StatelessWidget {
  final DayProperty dayProperty;
  final bool hasEvent;
  final Function(DateTime)? onTap;

  const WeeklyDayTile({
    super.key,
    required this.dayProperty,
    this.onTap,
    this.hasEvent = false,
  });

  DateTime get day => dayProperty.date;

  TextStyle _textStyle(BuildContext context) {
    final baseStyle = CalendarConstants.mediumDayTextStyle;
    final isSelected = dayProperty.selectionType == SelectionType.selected;

    if (isSelected) {
      return baseStyle.inverseColor(context);
    }

    if (dayProperty.dayType == DayType.outMonth) {
      return baseStyle.disabledColor(context);
    }

    return baseStyle.tertiaryColor(context);
  }

  @override
  Widget build(BuildContext context) {
    return OpacityWidgetButton.noDebounce(
      onTap: (_) => onTap?.call(day),
      useFastDoubleTap: true,
      child: _buildDate(context),
    );
  }

  Widget _buildDate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        Container(
          width: double.infinity,
          decoration: CalendarStyler.getCircleBoxDeco(context, dayProperty) ??
              const BoxDecoration(),
          padding: CalendarConstants.calendarTilePadding,
          child: Center(
            child: _buildDecoDayText(context, day.day.toString()),
          ),
        ),
        if (hasEvent) _buildEventIndicator(context),
      ],
    );
  }

  Widget _buildDecoDayText(BuildContext context, String text) {
    final textStyle = _textStyle(context);

    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  Widget _buildEventIndicator(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: context.bgDanger,
        shape: BoxShape.circle,
      ),
    );
  }
}

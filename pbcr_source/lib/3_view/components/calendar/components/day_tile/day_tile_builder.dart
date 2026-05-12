import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/calendar/components/day_tile/default_day_tile.dart';
import 'package:icreat_dct/3_view/components/calendar/data/day_property.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class DayTileBuilder {
  Widget build(
    BuildContext context,
    DateTime day,
    DateTime? selectedDay,
    DateTime focusedDay, {
    Function(DateTime)? onTap,
    Function(DateTime)? onDoubleTap,
  });
}

class DefaultDayTileBuilder implements DayTileBuilder {
  const DefaultDayTileBuilder();

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
    return DefaultDayTile(
      dayProperty: dayProperty,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';
import 'package:icreat_dct/3_view/components/calendar/components/day_tile/day_tile_builder.dart';
import 'package:icreat_dct/3_view/components/calendar/components/day_tile/default_day_tile.dart';
import 'package:icreat_dct/3_view/components/calendar/data/day_property.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:table_calendar/table_calendar.dart';

class EventDayTileBuilder extends DayTileBuilder {
  final List<ScheduleItemModel> Function(DateTime)? getSchedule;

  EventDayTileBuilder({
    this.getSchedule,
  });

  @override
  Widget build(
    BuildContext context,
    DateTime day,
    DateTime? selectedDay,
    DateTime focusedDay, {
    Function(DateTime)? onTap,
    Function(DateTime)? onDoubleTap,
  }) {
    final isSelectedDate = isSameDay(day, selectedDay);
    final dayType = DayType.fromDateTime(day, focusedDay);
    final dayProperty = DayProperty(
      date: day,
      dayType: dayType,
      selectionType: isSelectedDate ? SelectionType.selected : SelectionType.none,
    );

    final schedules = getSchedule?.call(day.toLocalize());
    final hasEvent = schedules?.isNotEmpty ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = 8.0;
        final halfOfWidth = constraints.maxWidth / 2;
        final centerX = halfOfWidth - circleSize / 2;

        return Stack(
          children: [
            DefaultDayTile(
                dayProperty: dayProperty,
                onTap: onTap,
                onDoubleTap: onDoubleTap
            ),
            if (!hasEvent)
              SizedBox.shrink(),
            if (hasEvent)
              Positioned(
                bottom: 4,
                right: centerX,
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: context.bgDanger,
                    shape: BoxShape.circle,
                  ),
                ),
              )
          ]
        );
      },
    );
  }
}

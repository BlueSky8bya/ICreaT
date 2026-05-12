import 'package:flutter/material.dart';
import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';
import 'package:icreat_dct/3_view/components/calendar/components/day_tile/day_tile_builder.dart';
import 'package:icreat_dct/3_view/components/calendar/components/range_day_tile/range_day_tile_builder.dart';
import 'package:icreat_dct/3_view/components/calendar/data/day_tile_size.dart';
import 'package:icreat_dct/3_view/components/calendar/data/range_marker_type.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyCalendarWidget extends StatefulWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final DateTime? firstDay;
  final DateTime? lastDay;
  final DateTime? rangeStartDay;
  final DateTime? rangeEndDay;

  // 옵션
  final DayTileBuilder dayTileBuilder;
  final DayTileSize dayTileSize;
  final CalendarFormat calendarFormat;

  final Function(DateTime)? onDaySelected;
  final Function(DateTime)? onDoubleTap;
  final Function(DateTime)? onFocusedDayChanged;

  final bool showHeader;

  // 이벤트 데이터를 받기 위한 새로운 파라미터
  final List<ScheduleItemModel>? events;

  const MonthlyCalendarWidget({
    super.key,
    this.selectedDay,
    required this.focusedDay,
    this.firstDay,
    this.lastDay,
    this.rangeStartDay,
    this.rangeEndDay,
    this.dayTileBuilder = const DefaultDayTileBuilder(),
    this.dayTileSize = DayTileSize.square,
    this.calendarFormat = CalendarFormat.month,
    this.onDaySelected,
    this.onDoubleTap,
    this.onFocusedDayChanged,
    this.events,
    this.showHeader = false
  });

  @override
  State<MonthlyCalendarWidget> createState() => _MonthlyCalendarWidgetState();
}

class _MonthlyCalendarWidgetState extends State<MonthlyCalendarWidget> {
  DateTime get _firstDay => widget.firstDay ?? DateTime(1970, 1, 1);
  DateTime get _lastDay => widget.lastDay ?? DateTime(2099, 12, 31);

  DateTime? get _rangeStartDay => widget.rangeStartDay;
  DateTime? get _rangeEndDay => widget.rangeEndDay;

  // 옵션
  double _dayTileHeight(BuildContext context) =>
      widget.dayTileSize.calculateHeight(context);

  Widget _buildHeader(BuildContext context) {
    final focusedDay = widget.focusedDay;
    final firstYear = _firstDay.year;
    final lastYear = _lastDay.year;

    final years = List<int>.generate(lastYear - firstYear + 1, (index) => firstYear + index);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton<int>(
            value: focusedDay.year,
            items: years.map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text('$year년'),
              );
            }).toList(),
            onChanged: (newYear) {
              if (newYear == null) return;
              final oldFocusedDay = widget.focusedDay;
              final daysInMonth =
                  DateUtils.getDaysInMonth(newYear, oldFocusedDay.month);
              final day =
                  oldFocusedDay.day > daysInMonth ? daysInMonth : oldFocusedDay.day;
              final newFocusedDay = DateTime(newYear, oldFocusedDay.month, day);
              if (newFocusedDay.isBefore(_firstDay)) {
                widget.onFocusedDayChanged?.call(_firstDay);
              } else if (newFocusedDay.isAfter(_lastDay)) {
                widget.onFocusedDayChanged?.call(_lastDay);
              } else {
                widget.onFocusedDayChanged?.call(newFocusedDay);
              }
            },
            style: TextStyles.headline2.primaryColor(context),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.arrow_drop_down),
          ),
          const SizedBox(width: 16),
          DropdownButton<int>(
            value: focusedDay.month,
            items: List.generate(12, (index) => index + 1).map((month) {
              return DropdownMenuItem<int>(
                value: month,
                child: Text(DateFormat.MMMM('ko').format(DateTime(0, month))),
              );
            }).toList(),
            onChanged: (newMonth) {
              if (newMonth == null) return;
              final oldFocusedDay = widget.focusedDay;
              final daysInMonth =
                  DateUtils.getDaysInMonth(oldFocusedDay.year, newMonth);
              final day =
                  oldFocusedDay.day > daysInMonth ? daysInMonth : oldFocusedDay.day;
              final newFocusedDay = DateTime(oldFocusedDay.year, newMonth, day);
              if (newFocusedDay.isBefore(_firstDay)) {
                widget.onFocusedDayChanged?.call(_firstDay);
              } else if (newFocusedDay.isAfter(_lastDay)) {
                widget.onFocusedDayChanged?.call(_lastDay);
              } else {
                widget.onFocusedDayChanged?.call(newFocusedDay);
              }
            },
            style: TextStyles.headline2.primaryColor(context),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.showHeader)
          _buildHeader(context),
        TableCalendar(
          availableGestures: AvailableGestures.horizontalSwipe,
          currentDay: widget.selectedDay,
          focusedDay: widget.focusedDay,
          firstDay: _firstDay,
          lastDay: _lastDay,
          rangeStartDay: _rangeStartDay,
          rangeEndDay: _rangeEndDay,
          calendarFormat: widget.calendarFormat,
          headerVisible: false,
          selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
          onPageChanged: (focusedDay) {
            widget.onFocusedDayChanged?.call(focusedDay);
          },
          // daysOfWeekHeight: 39,
          daysOfWeekHeight: 20,
          daysOfWeekStyle: DaysOfWeekStyle(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            weekdayStyle: TextStyles.body2.tertiaryColor(context),
            weekendStyle: TextStyles.body2.tertiaryColor(context),
            dowTextFormatter: dayTextFormatter,
          ),

          rowHeight: _dayTileHeight(context),
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, day, focusedDay) => _isInRange(day)
                ? _RangeDayTileWidget(
                    day: day,
                    focusedDay: widget.focusedDay,
                    markerType: _getRangeMarkerType(day),
                    onDaySelected: _onDaySelected,
                  )
                : widget.dayTileBuilder.build(
                    context,
                    day,
                    widget.selectedDay,
                    widget.focusedDay,
                    onTap: _onDaySelected,
                    onDoubleTap: widget.onDoubleTap,
                  ),
            todayBuilder: (context, day, focusedDay) => _isInRange(day)
                ? _RangeDayTileWidget(
                    day: day,
                    focusedDay: widget.focusedDay,
                    markerType: _getRangeMarkerType(day),
                    onDaySelected: _onDaySelected,
                  )
                : widget.dayTileBuilder.build(
                    context,
                    day,
                    widget.selectedDay,
                    widget.focusedDay,
                    onTap: _onDaySelected,
                    onDoubleTap: widget.onDoubleTap,
                  ),
            defaultBuilder: (context, day, focusedDay) =>
                widget.dayTileBuilder.build(
              context,
              day,
              widget.selectedDay,
              widget.focusedDay,
              onTap: _onDaySelected,
              onDoubleTap: widget.onDoubleTap,
            ),
            holidayBuilder: (context, day, focusedDay) =>
                widget.dayTileBuilder.build(
              context,
              day,
              widget.selectedDay,
              widget.focusedDay,
              onTap: _onDaySelected,
              onDoubleTap: widget.onDoubleTap,
            ),
            outsideBuilder: (context, day, focusedDay) =>
                widget.dayTileBuilder.build(
              context,
              day,
              widget.selectedDay,
              widget.focusedDay,
              onTap: _onDaySelected,
              onDoubleTap: widget.onDoubleTap,
            ),
            disabledBuilder: (context, day, focusedDay) =>
                widget.dayTileBuilder.build(
              context,
              day,
              widget.selectedDay,
              widget.focusedDay,
              onTap: _onDaySelected,
              onDoubleTap: widget.onDoubleTap,
            ),
            rangeStartBuilder: (context, day, focusedDay) =>
                _RangeDayTileWidget(
              day: day,
              focusedDay: widget.focusedDay,
              markerType: RangeMarkerType.start,
              onDaySelected: _onDaySelected,
            ),
            rangeEndBuilder: (context, day, focusedDay) => _RangeDayTileWidget(
              day: day,
              focusedDay: widget.focusedDay,
              markerType: RangeMarkerType.end,
              onDaySelected: _onDaySelected,
            ),
            withinRangeBuilder: (context, day, focusedDay) =>
                _RangeDayTileWidget(
              day: day,
              focusedDay: widget.focusedDay,
              markerType: RangeMarkerType.middle,
              onDaySelected: _onDaySelected,
            ),
          ),
        ),
      ],
    );
  }

  /// rangeStartDay와 rangeEndDay가 모두 존재하는지 확인
  bool get _hasCompleteRange => _rangeStartDay != null && _rangeEndDay != null;

  bool _isInRange(DateTime day) {
    if (!_hasCompleteRange) {
      return false;
    }

    return day.isBetween(_rangeStartDay!, _rangeEndDay!);
  }

  RangeMarkerType _getRangeMarkerType(DateTime day) {
    if (_hasCompleteRange) {
      if (day.isSameDate(widget.rangeStartDay!)) {
        return RangeMarkerType.start;
      } else if (day.isSameDate(widget.rangeEndDay!)) {
        return RangeMarkerType.end;
      } else {
        return RangeMarkerType.middle;
      }
    }

    return RangeMarkerType.single;
  }

  void _onDaySelected(DateTime day) {
    final localizedDay = day.toLocalize();
    if (localizedDay.isAfter(_lastDay) || localizedDay.isBefore(_firstDay)) {
      return;
    }
    widget.onDaySelected?.call(localizedDay);
  }

  String dayTextFormatter(DateTime date, dynamic events) {
    return _DayTextFormatter(date: date).format();
  }
}

class _RangeDayTileWidget extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final RangeMarkerType markerType;
  final Function(DateTime)? onDaySelected;

  const _RangeDayTileWidget({
    required this.day,
    required this.focusedDay,
    required this.markerType,
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return const BandRangeDayTileBuilder().build(
      context,
      day,
      focusedDay,
      markerType,
      onTap: onDaySelected,
    );
  }
}

class _DayTextFormatter {
  final DateTime date;

  _DayTextFormatter({required this.date});

  static final Map<int, String> _dayTextFormatter = {
    1: '월',
    2: '화',
    3: '수',
    4: '목',
    5: '금',
    6: '토',
    7: '일',
  };

  String format() => _dayTextFormatter[date.weekday] ?? '';
}
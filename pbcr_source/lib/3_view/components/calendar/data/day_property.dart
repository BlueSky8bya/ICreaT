import 'package:icreat_dct/8_extension/date_time_ext.dart';

enum DayType {
  today,
  inMonth,
  outMonth;

  static DayType fromDateTime(DateTime date, DateTime focusedDay) {
    if (date.isSameDate(DateTime.now())) return DayType.today;
    if (date.isSameMonth(focusedDay)) return DayType.inMonth;
    return DayType.outMonth;
  }
}

enum SelectionType {
  selected,
  focused,
  none;
}

class DayProperty {
  final DateTime date;
  final DayType dayType;
  final SelectionType selectionType;

  const DayProperty({
    required this.date,
    required this.dayType,
    required this.selectionType,
  });

  factory DayProperty.fromDateTime(
    DateTime date,
    DayType dayType,
    SelectionType selectionType,
  ) {
    return DayProperty(
      date: date,
      dayType: dayType,
      selectionType: selectionType,
    );
  }
}

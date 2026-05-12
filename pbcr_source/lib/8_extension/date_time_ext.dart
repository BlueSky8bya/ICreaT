import 'dart:io';

import 'package:intl/intl.dart';

class TimeConstant {
  static const secondsPerMinute = 60;
  static const minutesPerHour = 60;
  static const secondsPerHour = secondsPerMinute * minutesPerHour;
  static const secondsPerDay = 24 * secondsPerHour;
}

extension DateTimeExt on DateTime {
  static DateTime fromSecondOfDay(int seconds) {
    var hour = seconds ~/ TimeConstant.secondsPerHour;
    seconds -= hour * TimeConstant.secondsPerHour;
    var minute = seconds ~/ TimeConstant.secondsPerMinute;
    var second = seconds - minute * TimeConstant.secondsPerMinute;
    return DateTime.now().of(hour: hour, minute: minute, second: second);
  }

  int toSecondOfDay() {
    var total = hour * TimeConstant.secondsPerHour;
    total += minute * TimeConstant.secondsPerMinute;
    total += second;
    return total;
  }

  static DateTime getToday() {
    return DateTime.now().withStartTime();
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameTime(DateTime other) {
    return hour == other.hour &&
        minute == other.minute &&
        second == other.second;
  }

  Duration toTimeDuration() {
    return Duration(
      hours: hour,
      minutes: minute,
      seconds: second,
      milliseconds: millisecond,
    );
  }

  int toUnixTimeStamp() {
    return millisecondsSinceEpoch ~/ 1000;
  }

  int toStartDoseUnixTimeStamp() {
    return of(hour: 4, minute: 0, second: 0).toUnixTimeStamp();
  }

  int toEndDoseUnixTimeStamp() {
    return add(const Duration(days: 1))
        .of(hour: 3, minute: 59, second: 59)
        .toUnixTimeStamp();
  }

  int toStartUnixTimeStamp() {
    return of(hour: 0, minute: 0, second: 0).toUnixTimeStamp();
  }

  int toEndUnixTimeStamp() {
    return of(hour: 23, minute: 59, second: 59).toUnixTimeStamp();
  }

  DateTime of(
      {int? year, int? month, int? day, int? hour, int? minute, int? second}) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
    );
  }

  DateTime plusMonths(int plusMonth) {
    if (plusMonth == 0) return this;
    var monthCnt = year * 12 + month;
    var addedMonthCnt = monthCnt + plusMonth;
    var newYear = addedMonthCnt ~/ 12;
    var newMonth = addedMonthCnt % 12;
    return of(year: newYear, month: newMonth);
  }

  DateTime toLocalize() {
    return DateTime(year, month, day);
  }

  DateTime withStartTime() {
    return DateTime(year, month, day);
  }

  DateTime withEndTime() {
    return DateTime(year, month, day, 23, 59, 59, 999, 999);
  }

  bool isSameOrBefore(DateTime other) => isBefore(other) || isSameDate(other);

  bool isSameOrAfter(DateTime other) => isAfter(other) || isSameDate(other);

  bool isBetween(DateTime start, DateTime end) {
    return isSameOrAfter(start) && isSameOrBefore(end);
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  String toYM({String separator = '/'}) =>
      DateFormat('yyyy${separator}MM', Platform.localeName).format(this);

  String toMD({String separator = '/'}) =>
      DateFormat('MM${separator}dd', Platform.localeName).format(this);

  String toMDE({String separator = '/'}) =>
      DateFormat('MM${separator}dd(E)', Platform.localeName).format(this);

  /// foramt : 'MM-dd'
  String toDashMD() => DateFormat('MM-dd', Platform.localeName).format(this);

  /// foramt : 'yyyy-MM'
  String toDashYM() => DateFormat('yyyy-MM', Platform.localeName).format(this);

  /// foramt : 'yyyy-MM-dd'
  String toDashYMD() =>
      DateFormat('yyyy-MM-dd', Platform.localeName).format(this);

  /// fomat : 'yyyy-MM-dd(E)'
  String toDashYMDE() =>
      DateFormat('yyyy-MM-dd(E)', Platform.localeName).format(this);

  /// format : 'yyyy.MM.dd. a HH:mm'
  String toDashYMDAHM() =>
      DateFormat('yyyy-MM-dd a hh:mm', Platform.localeName).format(this);

  /// fomat : 'yyyy.MM.dd.'
  String toDotYMD() =>
      DateFormat('yyyy.MM.dd.', Platform.localeName).format(this);

  /// fomat : 'yyyy.MM.dd(E)'
  String toDotYMDE() =>
      DateFormat('yyyy.MM.dd(E)', Platform.localeName).format(this);

  /// format : 'yyyy.MM.dd. a h:mm'
  String toDotYMDAHM() =>
      DateFormat('yyyy.MM.dd. a hh:mm', Platform.localeName).format(this);

  /// format : 'E'
  String toDayOfWeek() => DateFormat('E', Platform.localeName).format(this);

  /// format : 'a'
  String toAmPm() => DateFormat('a', Platform.localeName).format(this);

  /// format : 'HH:mm'
  String toHM() => DateFormat('HH:mm', Platform.localeName).format(this);

  /// format : 'a${separator}hh:mm'
  String toAHM({String separator = ' '}) =>
      DateFormat('a${separator}hh:mm', Platform.localeName).format(this);

  /// format : 'M월 d일 E요일'
  String toKoreanMDE() =>
      DateFormat('M월 d일 E요일', Platform.localeName).format(this);

  /// format : 'yyyy년 M월'
  String toKoreanYM() =>
      DateFormat('yyyy년 M월', Platform.localeName).format(this);

  /// format : 'yyyy년 M월 d일'
  String toKoreanYMD() =>
      DateFormat('yyyy년 M월 d일', Platform.localeName).format(this);

  /// fomat : 'yyyy년 MM월 dd일 E요일'
  String toKoreanYMDE() =>
      DateFormat('yyyy년 MM월 dd일 E요일', Platform.localeName).format(this);

  /// fomat : 'yyyy년 MM월 dd일(E)'
  String toKoreanYMDE2() =>
      DateFormat('yyyy년 MM월 dd일(E)', Platform.localeName).format(this);

  /// format : 'yyyy년 M월 d일 a h:mm'
  String toKoreanYMDAHM() =>
      DateFormat('yyyy년 M월 d일 a hh:mm', Platform.localeName).format(this);

  /// format : 'yyyy년 M월 d일(E) a h:mm'
  String toKoreanYMDEAHM() =>
      DateFormat('yyyy년 M월 d일(E) a hh:mm', Platform.localeName).format(this);

  /// fomat : 'yyyy/MM/dd'
  String toSlashYMD() =>
      DateFormat('yyyy/MM/dd', Platform.localeName).format(this);

  /// fomat : 'yyyy/MM/dd(E)'
  String toSlashYMDE() =>
      DateFormat('yyyy/MM/dd(E)', Platform.localeName).format(this);

  /// format : 'yyyy/MM/dd a h:mm'
  String toSlashYMDAHM() =>
      DateFormat('yyyy/MM/dd a hh:mm', Platform.localeName).format(this);

  /// format : 'yyyy/MM/dd(E) a h:mm'
  String toSlashYMDEAHM() =>
      DateFormat('yyyy/MM/dd(E) a hh:mm', Platform.localeName).format(this);

  /// format : 'yyyy-MM-dd 15:00:00.000Z' -> 'yyyy-MM-ddT15:00:00.000Z'
  String toUtcStr() => toUtc().toString().replaceFirst(' ', 'T');

  String toDayOfWeekKorean() =>
      DateFormat('E', Platform.localeName).format(this);

  String toYMD() => DateFormat('yyyyMMdd', Platform.localeName).format(this);

  DateTime get firstDayOfMonth {
    return of(day: 1);
  }

  DateTime get lastDayOfMonth {
    return of(month: month + 1, day: 0);
  }

  String toYMDHMS() => DateFormat('yyyyMMddHHmmss', Platform.localeName).format(this);
}

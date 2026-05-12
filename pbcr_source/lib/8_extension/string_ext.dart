import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:fast_base58/fast_base58.dart';
import 'date_time_ext.dart';

extension StringExt on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }

  DateTime toDateTimeFromYMD() {
    final sanitized = replaceAll('-', '');
    return FixedDateTimeFormatter('YYYYMMDD').decode(sanitized);
  }

  DateTime toDateTimeFromHMS() {
    return FixedDateTimeFormatter('hh:mm:ss').decode(this);
  }

  DateTime toDateTimeFromYMDHM() {
    final sanitized = replaceAll('-', '');
    return FixedDateTimeFormatter('YYYYMMDD hh:mm').decode(sanitized);
  }

  DateTime toDateTimeFromHM({required DateTime ymd}) {
    return FixedDateTimeFormatter('hh:mm')
        .decode(this)
        .of(year: ymd.year, month: ymd.month, day: ymd.day);
  }

  String get toNonBreakWord {
    return split('').map((char) => '$char\uFEFF').join();
  }

  String get makeBreakOnlyAtSpace {
    return split(' ').map((word) => word.toNonBreakWord).join(' ');
  }

  List<String> chunked(int size) {
    var newSize = (length / size).ceil();
    List<String> newList = [];
    for (int idx = 0; idx < newSize; idx++) {
      var next = (idx + 1) * size;
      var lastIdx = length < next ? length : next;
      newList.add(substring(idx * size, lastIdx));
    }
    return newList;
  }

  List<int> fromHexToBytes() {
    return chunked(2).map((e) => int.parse(e, radix: 16)).toList();
  }

  String? get firstOrNull {
    try {
      return this[0];
    } catch (e) {
      return null;
    }
  }

  String? get lastOrNull {
    try {
      return this[length - 1];
    } catch (e) {
      return null;
    }
  }

  List<int> get bytes => runes.toList();
  List<int> get decodeBase64 => base64.decode(this);
  List<int> get decodeBase58 => Base58Decode(this);

  String get replaceForUrl => replaceAll('\u0026', '&');

  bool equalIgnoreCase(String other) {
    return toLowerCase() == other.toLowerCase();
  }
}

extension NullableStringExt on String? {
  bool get isNullOrEmpty => this == null || this?.isEmpty == true;
  bool get isNotEmpty => this?.isNotEmpty == true;
}

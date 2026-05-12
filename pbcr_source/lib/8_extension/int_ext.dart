import 'package:intl/intl.dart';

extension IntExt on int {
  static final NumberFormat _currencyFormatter =
      NumberFormat.simpleCurrency(locale: 'ko');
  static final NumberFormat _commaFormatter = NumberFormat('###,###,###,###');

  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }

  static const int _byteMask = 0xff;
  List<int> toByteList(int byteSize, {bool isLittleEndian = false}) {
    final result = List.generate(byteSize, (index) => 0);

    for (var i = 0; i < byteSize; i++) {
      final preProcessData = this >> i * 8;
      result[isLittleEndian ? i : result.length - (i + 1)] =
          preProcessData & _byteMask;
    }

    return result;
  }

  String toCurrencyStr() => _currencyFormatter.format(this);
  String toStrWithComma() => _commaFormatter.format(this);
  String toHexString() => toRadixString(16).padLeft(2, '0');

  static const int _fileSizeUnit = 1024;
  String get fileSize {
    if (this < _fileSizeUnit) return '$this Bytes';

    final kb = this / _fileSizeUnit;
    if (kb < _fileSizeUnit) return '${kb.toStringAsFixed(1)} KB';

    final mb = kb / _fileSizeUnit;
    if (mb < _fileSizeUnit) return '${mb.toStringAsFixed(1)} MB';

    final gb = mb / _fileSizeUnit;
    return '${gb.toStringAsFixed(1)} GB';
  }

  String get fileProcessTime {
    var totalSec = this + 1;
    final hour = totalSec ~/ 3600;
    final min = (totalSec ~/ 60) % 60;
    final sec = totalSec % 60;

    String time = '$sec초';

    if (min > 0) {
      time = '$min분 $time';
    }
    if (hour > 0) {
      '$hour시간 $time';
    }

    return time;
  }

  int roundToNearest(int nearest) {
    int rounded = (this + nearest / 2) ~/ nearest * nearest;
    return rounded % 60;
  }
}

extension BoolExt on bool {
  static const String trueStr = 'T';
  static const String falseStr = 'F';

  static bool? parseStr(String value) {
    if (value == trueStr) {
      return true;
    } else if (value == falseStr) {
      return false;
    }

    return null;
  }

  String get str => this ? trueStr : falseStr;
}

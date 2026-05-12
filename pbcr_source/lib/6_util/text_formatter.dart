class TextFormatter {
  /// 숫자를 n개의 자릿수마다 ,를 삽입해서 String으로 반환합니다.
  ///
  /// [number] 포맷할 숫자
  /// [digit] 콤마를 삽입할 자릿수 단위 (기본값: 3)
  static String insertComma(int number, [int digit = 3]) {
    final numberStr = number.toString();
    final buffer = StringBuffer();
    final length = numberStr.length;

    for (var i = 0; i < length; i++) {
      if (i > 0 && (length - i) % digit == 0) {
        buffer.write(',');
      }
      buffer.write(numberStr[i]);
    }

    return buffer.toString();
  }
}

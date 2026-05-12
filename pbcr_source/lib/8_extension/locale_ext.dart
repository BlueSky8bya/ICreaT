import 'dart:ui';

extension LocaleExt on Locale? {
  bool get isKorea =>
      this == const Locale('ko') || this == const Locale('ko', 'KR');
  bool get isAmerica =>
      this == const Locale('en') || this == const Locale('en', 'EN');
  // (Get.locale?.isAmerica ?? false)
}

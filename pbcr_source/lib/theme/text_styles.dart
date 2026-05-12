import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/color_hue.dart';

class FontSizes {
  static double get scale => 1;
  static double get s10 => 10 * scale;
  static double get s11 => 11 * scale;
  static double get s12 => 12 * scale;
  static double get s13 => 13 * scale;
  static double get s14 => 14 * scale;
  static double get s13_5 => 13.5 * scale;
  static double get s15 => 15 * scale;
  static double get s18 => 18 * scale;
  static double get s21 => 21 * scale;
  static double get s24 => 24 * scale;
  static double get s30 => 30 * scale;
  static double get s32 => 32 * scale;
}

class Fonts {
  static const String pretendard = 'Pretendard';
}

class TextStyles {
  TextStyles._();

  static const TextStyle base = TextStyle(
    fontFamily: Fonts.pretendard,
    color: ColorHue.black,
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 1.3,
    leadingDistribution: TextLeadingDistribution.even,
  ); // height: 130%

  /// 24
  static TextStyle headline1 =
      base.copyWith(fontSize: 24, height: 1.3); // height: 130%
  /// 20
  static TextStyle headline2 =
      base.copyWith(fontSize: 20, height: 1.4); // height: 140%
  /// 18
  static TextStyle headline3 =
      base.copyWith(fontSize: 18, height: 1.4); // height: 140%
  /// 16
  static TextStyle body1 =
      base.copyWith(fontSize: 16, height: 1.4); // height: 140%
  /// 14
  static TextStyle body2 =
      base.copyWith(fontSize: 14, height: 1.3); // height: 130%
  /// 13
  static TextStyle caption1 =
      base.copyWith(fontSize: 13, height: 1.3); // height: 130%
  /// 11
  static TextStyle caption2 =
      base.copyWith(fontSize: 11, height: 1.3); // height: 130%

  static TextStyle tiny =
      base.copyWith(fontSize: 8, height: 1.3); // height: 130%

  // 나중에 Light,Dark Theme 기능 추가 시 활용
  // 지금은 default font 용도로만
  static TextTheme makeTextTheme({
    Color? color,
  }) => TextTheme(
        displayLarge: base.copyWith(
          fontSize: 94,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
        ),
        displayMedium: base.copyWith(
          fontSize: 59,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        displaySmall: base.copyWith(
          fontSize: 47,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: base.copyWith(
          fontSize: 33,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        headlineSmall: base.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: base.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleMedium: base.copyWith(
          fontSize: 19,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        titleSmall: base.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: base.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: base, // default 폰트 (style 값 null일 때 bodyMedium 적용)
        bodySmall: base.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.25,
        ),
        labelLarge: base.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelSmall: base.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      );

  // LEGACY
  static TextStyle second =
      base.copyWith(fontSize: FontSizes.s30, fontWeight: FontWeight.bold);
  static TextStyle h2 =
      base.copyWith(fontSize: FontSizes.s24, fontWeight: FontWeight.bold);
  static TextStyle thumbnailTitle = base.copyWith(fontSize: 40);
}


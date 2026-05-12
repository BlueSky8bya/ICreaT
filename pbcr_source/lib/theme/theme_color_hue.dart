import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/color_hue.dart';
import 'package:icreat_dct/theme/theme_color.dart';

class ThemeColorHue {
  static BuildContext? context;

  static void setContext(BuildContext context) {
    ThemeColorHue.context = context;
  }

  // ----------------- TEXT -----------------

  // Brand Colors
  static const ThemeColor textBrand = ThemeColor(
    light: ColorHue.purple500,
    dark: ColorHue.purple300,
  );

  static const ThemeColor textBrandHoverPressed = ThemeColor(
    light: ColorHue.purple700,
    dark: ColorHue.purple400,
  );

  // Primary Colors
  static const ThemeColor textPrimary = ThemeColor(
    light: ColorHue.gray900,
    dark: ColorHue.white,
  );

  static const ThemeColor textPrimaryHoverPressed = ThemeColor(
    light: ColorHue.black,
    dark: ColorHue.white,
  );

  // Secondary Colors
  static const ThemeColor textSecondary = ThemeColor(
    light: ColorHue.gray700,
    dark: ColorHue.gray200,
  );

  static const ThemeColor textSecondaryHoverPressed = ThemeColor(
    light: ColorHue.gray800,
    dark: ColorHue.gray100,
  );

  // Tertiary Colors
  static const ThemeColor textTertiary = ThemeColor(
    light: ColorHue.gray600,
    dark: ColorHue.gray300,
  );

  static const ThemeColor textTertiaryHoverPressed = ThemeColor(
    light: ColorHue.gray700,
    dark: ColorHue.gray200,
  );

  // Disabled Colors
  static const ThemeColor textDisabled = ThemeColor(
    light: ColorHue.gray500,
    dark: ColorHue.gray600,
  );

  // Inverse Colors
  static const ThemeColor textInverse = ThemeColor(
    light: ColorHue.white,
    dark: ColorHue.black,
  );

  // Danger Colors
  static const ThemeColor textDanger = ThemeColor(
    light: ColorHue.red500,
    dark: ColorHue.red300,
  );

  static const ThemeColor textDangerBold = ThemeColor(
    light: ColorHue.red700,
    dark: ColorHue.red400,
  );

  // Info Colors
  static const ThemeColor textInfo = ThemeColor(
    light: ColorHue.blue500,
    dark: ColorHue.blue300,
  );

  static const ThemeColor textInfoBold = ThemeColor(
    light: ColorHue.blue800,
    dark: ColorHue.blue400,
  );

  // Warning Colors
  static const ThemeColor textWarning = ThemeColor(
    light: ColorHue.yellow500,
    dark: ColorHue.yellow200,
  );

  static const ThemeColor textWarningBold = ThemeColor(
    light: ColorHue.yellow800,
    dark: ColorHue.yellow400,
  );

  // Success Colors
  static const ThemeColor textSuccess = ThemeColor(
    light: ColorHue.lime700,
    dark: ColorHue.lime200,
  );

  static const ThemeColor textSuccessHoverPressed = ThemeColor(
    light: ColorHue.lime800,
    dark: ColorHue.lime400,
  );

  // ----------------- BACKGROUND -----------------

  static const ThemeColor bgBrandSubtitle = ThemeColor(
    light: ColorHue.purple50,
    dark: ColorHue.purple800,
  );

  static const ThemeColor bgBrand = ThemeColor(
    light: ColorHue.purple500,
    dark: ColorHue.purple300,
  );

  static const ThemeColor bgBrandHoverPressed = ThemeColor(
    light: ColorHue.purple700,
    dark: ColorHue.purple400,
  );

  static const ThemeColor bgPrimary = ThemeColor(
    light: ColorHue.white,
    dark: ColorHue.gray900,
  );

  static const ThemeColor bgPrimaryHoverPressed = ThemeColor(
    light: ColorHue.gray50,
    dark: ColorHue.gray800,
  );

  static const ThemeColor bgSecondary = ThemeColor(
    light: ColorHue.lime500,
    dark: ColorHue.lime200,
  );

  static const ThemeColor bgSecondaryHoverPressed = ThemeColor(
    light: ColorHue.lime700,
    dark: ColorHue.lime400,
  );

  static const ThemeColor bgTertiary = ThemeColor(
    light: ColorHue.gray100,
    dark: ColorHue.gray700,
  );

  static const ThemeColor bgTertiaryHoverPressed = ThemeColor(
    light: ColorHue.gray200,
    dark: ColorHue.gray600,
  );

  static const ThemeColor bgDisabled = ThemeColor(
    light: ColorHue.gray300,
    dark: ColorHue.gray300,
  );

  static const ThemeColor bgDangerSubtitle = ThemeColor(
    light: ColorHue.red50,
    dark: ColorHue.red800,
  );

  static const ThemeColor bgDanger = ThemeColor(
    light: ColorHue.red500,
    dark: ColorHue.red300,
  );

  static const ThemeColor bgDangerBold = ThemeColor(
    light: ColorHue.red700,
    dark: ColorHue.red400,
  );

  static const ThemeColor bgInfoSubtitle = ThemeColor(
    light: ColorHue.blue50,
    dark: ColorHue.blue800,
  );

  static const ThemeColor bgInfoBold = ThemeColor(
    light: ColorHue.blue500,
    dark: ColorHue.blue400,
  );

  static const ThemeColor bgWarningSubtitle = ThemeColor(
    light: ColorHue.yellow50,
    dark: ColorHue.yellow800,
  );

  static const ThemeColor bgWarningBold = ThemeColor(
    light: ColorHue.yellow500,
    dark: ColorHue.yellow600,
  );

  static const ThemeColor bgSuccessSubtitle = ThemeColor(
    light: ColorHue.lime50,
    dark: ColorHue.lime800,
  );

  static const ThemeColor bgSuccessBold = ThemeColor(
    light: ColorHue.lime500,
    dark: ColorHue.lime200,
  );

  static const ThemeColor bgInverseBold = ThemeColor(
    light: ColorHue.gray900,
    dark: ColorHue.gray100,
  );

  // ----------------- ICON -----------------

  static const ThemeColor iconBrand = ThemeColor(
    light: ColorHue.purple500,
    dark: ColorHue.purple300,
  );

  static const ThemeColor iconPrimary = ThemeColor(
    light: ColorHue.gray900,
    dark: ColorHue.white,
  );

  static const ThemeColor iconSecondary = ThemeColor(
    light: ColorHue.gray700,
    dark: ColorHue.gray200,
  );

  static const ThemeColor iconTertiary = ThemeColor(
    light: ColorHue.gray600,
    dark: ColorHue.gray300,
  );

  static const ThemeColor iconDisabled = ThemeColor(
    light: ColorHue.gray500,
    dark: ColorHue.gray600,
  );

  static const ThemeColor iconInverse = ThemeColor(
    light: ColorHue.white,
    dark: ColorHue.black,
  );

  static const ThemeColor iconDanger = ThemeColor(
    light: ColorHue.red500,
    dark: ColorHue.red300,
  );

  static const ThemeColor iconInfo = ThemeColor(
    light: ColorHue.blue500,
    dark: ColorHue.blue300,
  );

  static const ThemeColor iconWarning = ThemeColor(
    light: ColorHue.yellow500,
    dark: ColorHue.yellow200,
  );

  static const ThemeColor iconSuccess = ThemeColor(
    light: ColorHue.lime700,
    dark: ColorHue.lime200,
  );

  // ----------------- BORDER -----------------

  static const ThemeColor borderBrand = ThemeColor(
    light: ColorHue.purple500,
    dark: ColorHue.purple300,
  );

  static const ThemeColor borderBrandHoverPressed = ThemeColor(
    light: ColorHue.purple700,
    dark: ColorHue.purple400,
  );

  static const ThemeColor borderPrimary = ThemeColor(
    light: ColorHue.gray200,
    dark: ColorHue.gray700,
  );

  static const ThemeColor borderPrimaryHoverPressed = ThemeColor(
    light: ColorHue.gray400,
    dark: ColorHue.gray600,
  );

  static const ThemeColor borderDisabled = ThemeColor(
    light: ColorHue.gray500,
    dark: ColorHue.gray500,
  );

  static const ThemeColor borderDangerSubtitle = ThemeColor(
    light: ColorHue.red50,
    dark: ColorHue.red800,
  );

  static const ThemeColor borderDanger = ThemeColor(
    light: ColorHue.red500,
    dark: ColorHue.red300,
  );

  static const ThemeColor borderInfoSubtitle = ThemeColor(
    light: ColorHue.blue50,
    dark: ColorHue.blue800,
  );

  static const ThemeColor borderInfoBold = ThemeColor(
    light: ColorHue.blue800,
    dark: ColorHue.blue400,
  );

  static const ThemeColor borderWarningSubtitle = ThemeColor(
    light: ColorHue.yellow50,
    dark: ColorHue.yellow800,
  );

  static const ThemeColor borderWarningBold = ThemeColor(
    light: ColorHue.yellow500,
    dark: ColorHue.yellow600,
  );

  static const ThemeColor borderSuccessSubtitle = ThemeColor(
    light: ColorHue.lime50,
    dark: ColorHue.lime800,
  );

  static const ThemeColor borderSuccessBold = ThemeColor(
    light: ColorHue.lime500,
    dark: ColorHue.lime200,
  );

  // custom

  static const ThemeColor calendarText = ThemeColor(
    light: ColorHue.gray900,
    dark: ColorHue.black,
  );
}

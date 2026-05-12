import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/color_hue.dart';
import 'package:icreat_dct/theme/extenstion/custom_color_theme_extension.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';
import 'package:icreat_dct/theme/theme_color_hue.dart';

/// white: 밝은 배경에 사용되는 테마 수식어
/// black: 어두운 배경에 사용되는 테마 수식어
/// white 테마라고 색상이 흰색이라는 뜻은 아님
class ThemeDataPresets {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ThemeColorHue.bgPrimary.light,
    textTheme: _lightTextTheme,
    appBarTheme: _lightAppBarTheme,
    iconTheme: _lightIconTheme,
    colorScheme: _lightColorscheme,
    extensions: [
      ThemeColorsExt(
        textBrand: ThemeColorHue.textBrand.light,
        textBrandHoverPressed: ThemeColorHue.textBrandHoverPressed.light,
        textPrimary: ThemeColorHue.textPrimary.light,
        textPrimaryHoverPressed: ThemeColorHue.textPrimaryHoverPressed.light,
        textSecondary: ThemeColorHue.textSecondary.light,
        textSecondaryHoverPressed:
            ThemeColorHue.textSecondaryHoverPressed.light,
        textTertiary: ThemeColorHue.textTertiary.light,
        textTertiaryHoverPressed: ThemeColorHue.textTertiaryHoverPressed.light,
        textDisabled: ThemeColorHue.textDisabled.light,
        textInverse: ThemeColorHue.textInverse.light,
        textDanger: ThemeColorHue.textDanger.light,
        textDangerBold: ThemeColorHue.textDangerBold.light,
        textInfo: ThemeColorHue.textInfo.light,
        textInfoBold: ThemeColorHue.textInfoBold.light,
        textWarning: ThemeColorHue.textWarning.light,
        textWarningBold: ThemeColorHue.textWarningBold.light,
        textSuccess: ThemeColorHue.textSuccess.light,
        textSuccessHoverPressed: ThemeColorHue.textSuccessHoverPressed.light,
        bgBrandSubtitle: ThemeColorHue.bgBrandSubtitle.light,
        bgBrand: ThemeColorHue.bgBrand.light,
        bgBrandHoverPressed: ThemeColorHue.bgBrandHoverPressed.light,
        bgPrimary: ThemeColorHue.bgPrimary.light,
        bgPrimaryHoverPressed: ThemeColorHue.bgPrimaryHoverPressed.light,
        bgSecondary: ThemeColorHue.bgSecondary.light,
        bgSecondaryHoverPressed: ThemeColorHue.bgSecondaryHoverPressed.light,
        bgTertiary: ThemeColorHue.bgTertiary.light,
        bgTertiaryHoverPressed: ThemeColorHue.bgTertiaryHoverPressed.light,
        bgDisabled: ThemeColorHue.bgDisabled.light,
        bgDangerSubtitle: ThemeColorHue.bgDangerSubtitle.light,
        bgDanger: ThemeColorHue.bgDanger.light,
        bgDangerBold: ThemeColorHue.bgDangerBold.light,
        bgInfoSubtitle: ThemeColorHue.bgInfoSubtitle.light,
        bgInfo: ThemeColorHue.bgInfoBold.light,
        bgWarningSubtitle: ThemeColorHue.bgWarningSubtitle.light,
        bgWarning: ThemeColorHue.bgWarningBold.light,
        bgSuccessSubtitle: ThemeColorHue.bgSuccessSubtitle.light,
        bgSuccess: ThemeColorHue.bgSuccessBold.light,
        bgInverseBold: ThemeColorHue.bgInverseBold.light,
        iconBrand: ThemeColorHue.iconBrand.light,
        iconPrimary: ThemeColorHue.iconPrimary.light,
        iconSecondary: ThemeColorHue.iconSecondary.light,
        iconTertiary: ThemeColorHue.iconTertiary.light,
        iconDisabled: ThemeColorHue.iconDisabled.light,
        iconInverse: ThemeColorHue.iconInverse.light,
        iconDanger: ThemeColorHue.iconDanger.light,
        iconInfo: ThemeColorHue.iconInfo.light,
        iconWarning: ThemeColorHue.iconWarning.light,
        iconSuccess: ThemeColorHue.iconSuccess.light,
        borderBrand: ThemeColorHue.borderBrand.light,
        borderBrandHoverPressed: ThemeColorHue.borderBrandHoverPressed.light,
        borderPrimary: ThemeColorHue.borderPrimary.light,
        borderPrimaryHoverPressed:
            ThemeColorHue.borderPrimaryHoverPressed.light,
        borderDisabled: ThemeColorHue.borderDisabled.light,
        borderDangerSubtitle: ThemeColorHue.borderDangerSubtitle.light,
        borderDanger: ThemeColorHue.borderDanger.light,
        borderInfoSubtitle: ThemeColorHue.borderInfoSubtitle.light,
        borderInfoBold: ThemeColorHue.borderInfoBold.light,
        borderWarningSubtitle: ThemeColorHue.borderWarningSubtitle.light,
        borderWarningBold: ThemeColorHue.borderWarningBold.light,
        borderSuccessSubtitle: ThemeColorHue.borderSuccessSubtitle.light,
        borderSuccessBold: ThemeColorHue.borderSuccessBold.light,
        calendarText: ThemeColorHue.calendarText.light,
      )
    ],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ThemeColorHue.bgPrimary.dark,
    textTheme: _darkTextTheme,
    appBarTheme: _darkAppBarTheme,
    iconTheme: _darkIconTheme,
    colorScheme: _darkColorscheme,
    extensions: [
      ThemeColorsExt(
        textBrand: ThemeColorHue.textBrand.dark,
        textBrandHoverPressed: ThemeColorHue.textBrandHoverPressed.dark,
        textPrimary: ThemeColorHue.textPrimary.dark,
        textPrimaryHoverPressed: ThemeColorHue.textPrimaryHoverPressed.dark,
        textSecondary: ThemeColorHue.textSecondary.dark,
        textSecondaryHoverPressed: ThemeColorHue.textSecondaryHoverPressed.dark,
        textTertiary: ThemeColorHue.textTertiary.dark,
        textTertiaryHoverPressed: ThemeColorHue.textTertiaryHoverPressed.dark,
        textDisabled: ThemeColorHue.textDisabled.dark,
        textInverse: ThemeColorHue.textInverse.dark,
        textDanger: ThemeColorHue.textDanger.dark,
        textDangerBold: ThemeColorHue.textDangerBold.dark,
        textInfo: ThemeColorHue.textInfo.dark,
        textInfoBold: ThemeColorHue.textInfoBold.dark,
        textWarning: ThemeColorHue.textWarning.dark,
        textWarningBold: ThemeColorHue.textWarningBold.dark,
        textSuccess: ThemeColorHue.textSuccess.dark,
        textSuccessHoverPressed: ThemeColorHue.textSuccessHoverPressed.dark,
        bgBrandSubtitle: ThemeColorHue.bgBrandSubtitle.dark,
        bgBrand: ThemeColorHue.bgBrand.dark,
        bgBrandHoverPressed: ThemeColorHue.bgBrandHoverPressed.dark,
        bgPrimary: ThemeColorHue.bgPrimary.dark,
        bgPrimaryHoverPressed: ThemeColorHue.bgPrimaryHoverPressed.dark,
        bgSecondary: ThemeColorHue.bgSecondary.dark,
        bgSecondaryHoverPressed: ThemeColorHue.bgSecondaryHoverPressed.dark,
        bgTertiary: ThemeColorHue.bgTertiary.dark,
        bgTertiaryHoverPressed: ThemeColorHue.bgTertiaryHoverPressed.dark,
        bgDisabled: ThemeColorHue.bgDisabled.dark,
        bgDangerSubtitle: ThemeColorHue.bgDangerSubtitle.dark,
        bgDanger: ThemeColorHue.bgDanger.dark,
        bgDangerBold: ThemeColorHue.bgDangerBold.dark,
        bgInfoSubtitle: ThemeColorHue.bgInfoSubtitle.dark,
        bgInfo: ThemeColorHue.bgInfoBold.dark,
        bgWarningSubtitle: ThemeColorHue.bgWarningSubtitle.dark,
        bgWarning: ThemeColorHue.bgWarningBold.dark,
        bgSuccessSubtitle: ThemeColorHue.bgSuccessSubtitle.dark,
        bgSuccess: ThemeColorHue.bgSuccessBold.dark,
        bgInverseBold: ThemeColorHue.bgInverseBold.dark,
        iconBrand: ThemeColorHue.iconBrand.dark,
        iconPrimary: ThemeColorHue.iconPrimary.dark,
        iconSecondary: ThemeColorHue.iconSecondary.dark,
        iconTertiary: ThemeColorHue.iconTertiary.dark,
        iconDisabled: ThemeColorHue.iconDisabled.dark,
        iconInverse: ThemeColorHue.iconInverse.dark,
        iconDanger: ThemeColorHue.iconDanger.dark,
        iconInfo: ThemeColorHue.iconInfo.dark,
        iconWarning: ThemeColorHue.iconWarning.dark,
        iconSuccess: ThemeColorHue.iconSuccess.dark,
        borderBrand: ThemeColorHue.borderBrand.dark,
        borderBrandHoverPressed: ThemeColorHue.borderBrandHoverPressed.dark,
        borderPrimary: ThemeColorHue.borderPrimary.dark,
        borderPrimaryHoverPressed: ThemeColorHue.borderPrimaryHoverPressed.dark,
        borderDisabled: ThemeColorHue.borderDisabled.dark,
        borderDangerSubtitle: ThemeColorHue.borderDangerSubtitle.dark,
        borderDanger: ThemeColorHue.borderDanger.dark,
        borderInfoSubtitle: ThemeColorHue.borderInfoSubtitle.dark,
        borderInfoBold: ThemeColorHue.borderInfoBold.dark,
        borderWarningSubtitle: ThemeColorHue.borderWarningSubtitle.dark,
        borderWarningBold: ThemeColorHue.borderWarningBold.dark,
        borderSuccessSubtitle: ThemeColorHue.borderSuccessSubtitle.dark,
        borderSuccessBold: ThemeColorHue.borderSuccessBold.dark,
        calendarText: ThemeColorHue.calendarText.dark,
      )
    ],
  );

  // --- 색상 테마

  static final ColorScheme _lightColorscheme = ColorScheme.light(
    surfaceDim: ThemeColorHue.bgPrimaryHoverPressed.light,
    surface: ThemeColorHue.bgPrimary.light,
    surfaceBright: ThemeColorHue.bgPrimary.light,
    onSurface: ThemeColorHue.textPrimary.light,
    onSurfaceVariant: ThemeColorHue.textPrimaryHoverPressed.light,
    outline: ThemeColorHue.borderPrimary.light,
    outlineVariant: ThemeColorHue.borderPrimaryHoverPressed.light,
    inverseSurface: ThemeColorHue.bgInverseBold.light,
    onInverseSurface: ThemeColorHue.textInverse.light,
    shadow: ColorHue.black,
    scrim: ColorHue.black,
  );

  static final ColorScheme _darkColorscheme = ColorScheme.dark(
    surfaceDim: ThemeColorHue.bgPrimary.dark,
    surface: ThemeColorHue.bgPrimary.dark,
    surfaceBright: ThemeColorHue.bgTertiary.dark,
    onSurface: ThemeColorHue.textPrimary.dark,
    onSurfaceVariant: ThemeColorHue.textPrimaryHoverPressed.dark,
    outline: ThemeColorHue.borderPrimary.dark,
    outlineVariant: ThemeColorHue.borderPrimaryHoverPressed.dark,
    inverseSurface: ThemeColorHue.bgInverseBold.dark,
    onInverseSurface: ThemeColorHue.textInverse.dark,
    shadow: ColorHue.black,
    scrim: ColorHue.black,
  );

  // --- 앱바 테마

  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    backgroundColor: ThemeColorHue.bgPrimary.light,
    foregroundColor: ThemeColorHue.textPrimary.light,
    titleTextStyle: TextStyles.body1.medium.fromColor(
      ThemeColorHue.textPrimary.light,
    ),
    actionsIconTheme: _lightIconTheme,
    iconTheme: _lightIconTheme,
  );

  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    backgroundColor: ThemeColorHue.bgPrimary.dark,
    foregroundColor: ThemeColorHue.textPrimary.dark,
    titleTextStyle: TextStyles.body1.medium.fromColor(
      ThemeColorHue.textPrimary.dark,
    ),
    actionsIconTheme: _darkIconTheme,
    iconTheme: _darkIconTheme,
  );

  // --- 텍스트 테마

  static TextTheme getTextTheme(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? _lightTextTheme : _darkTextTheme;
  }

  static final TextTheme _lightTextTheme = TextStyles.makeTextTheme();

  static final TextTheme _darkTextTheme = TextStyles.makeTextTheme(
    color: ThemeColorHue.textPrimary.dark,
  );

  // static final TextTheme _lightTextTheme = TextTheme(
  //   // displayLarge: ,
  //   // displayMedium: ,
  //   // displaySmall: ,
  //   // headlineLarge: ,
  //   // headlineMedium: ,
  //   // headlineSmall: ,
  //   // titleLarge: ,
  //   titleMedium: TextStyles.headline1,
  //   titleSmall: TextStyles.headline2,
  //   bodyLarge: TextStyles.headline3,
  //   bodyMedium: TextStyles.body1,
  //   bodySmall: TextStyles.body2,
  //   labelLarge: TextStyles.caption1,
  //   labelMedium: TextStyles.caption2,
  //   labelSmall: TextStyles.tiny,
  // );

  // static final TextTheme _darkTextTheme = TextTheme(
  //   // displayLarge: ,
  //   // displayMedium: ,
  //   // displaySmall: ,
  //   // headlineLarge: ,
  //   // headlineMedium: ,
  //   // headlineSmall: ,
  //   // titleLarge: ,
  //   titleMedium: TextStyles.headline1.copyWith(color: ColorHue.white),
  //   titleSmall: TextStyles.headline2.copyWith(color: ColorHue.white),
  //   bodyLarge: TextStyles.headline3.copyWith(color: ColorHue.white),
  //   bodyMedium: TextStyles.body1.copyWith(color: ColorHue.white),
  //   bodySmall: TextStyles.body2.copyWith(color: ColorHue.white),
  //   labelLarge: TextStyles.caption1.copyWith(color: ColorHue.white),
  //   labelMedium: TextStyles.caption2.copyWith(color: ColorHue.white),
  //   labelSmall: TextStyles.tiny.copyWith(color: ColorHue.white),
  // );

  // --- 아이콘 테마

  static IconThemeData getIconTheme(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? _lightIconTheme : _darkIconTheme;
  }

  static final IconThemeData _lightIconTheme = IconThemeData(
    color: ThemeColorHue.iconPrimary.light,
  );

  static final IconThemeData _darkIconTheme = IconThemeData(
    color: ThemeColorHue.iconPrimary.dark,
  );
}

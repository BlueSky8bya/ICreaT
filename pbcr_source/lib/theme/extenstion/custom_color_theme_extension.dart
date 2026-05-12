import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/theme_color_hue.dart';

class ThemeColorsExt extends ThemeExtension<ThemeColorsExt> {
  final Color textBrand;
  final Color textBrandHoverPressed;
  final Color textPrimary;
  final Color textPrimaryHoverPressed;
  final Color textSecondary;
  final Color textSecondaryHoverPressed;
  final Color textTertiary;
  final Color textTertiaryHoverPressed;
  final Color textDisabled;
  final Color textInverse;
  final Color textDanger;
  final Color textDangerBold;
  final Color textInfo;
  final Color textInfoBold;
  final Color textWarning;
  final Color textWarningBold;
  final Color textSuccess;
  final Color textSuccessHoverPressed;
  final Color bgBrandSubtitle;
  final Color bgBrand;
  final Color bgBrandHoverPressed;
  final Color bgPrimary;
  final Color bgPrimaryHoverPressed;
  final Color bgSecondary;
  final Color bgSecondaryHoverPressed;
  final Color bgTertiary;
  final Color bgTertiaryHoverPressed;
  final Color bgDisabled;
  final Color bgDangerSubtitle;
  final Color bgDanger;
  final Color bgDangerBold;
  final Color bgInfoSubtitle;
  final Color bgInfo;
  final Color bgWarningSubtitle;
  final Color bgWarning;
  final Color bgSuccessSubtitle;
  final Color bgSuccess;
  final Color bgInverseBold;
  final Color iconBrand;
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color iconDisabled;
  final Color iconInverse;
  final Color iconDanger;
  final Color iconInfo;
  final Color iconWarning;
  final Color iconSuccess;
  final Color borderBrand;
  final Color borderBrandHoverPressed;
  final Color borderPrimary;
  final Color borderPrimaryHoverPressed;
  final Color borderDisabled;
  final Color borderDangerSubtitle;
  final Color borderDanger;
  final Color borderInfoSubtitle;
  final Color borderInfoBold;
  final Color borderWarningSubtitle;
  final Color borderWarningBold;
  final Color borderSuccessSubtitle;
  final Color borderSuccessBold;
  final Color calendarText;

  ThemeColorsExt({
    required this.textBrand,
    required this.textBrandHoverPressed,
    required this.textPrimary,
    required this.textPrimaryHoverPressed,
    required this.textSecondary,
    required this.textSecondaryHoverPressed,
    required this.textTertiary,
    required this.textTertiaryHoverPressed,
    required this.textDisabled,
    required this.textInverse,
    required this.textDanger,
    required this.textDangerBold,
    required this.textInfo,
    required this.textInfoBold,
    required this.textWarning,
    required this.textWarningBold,
    required this.textSuccess,
    required this.textSuccessHoverPressed,
    required this.bgBrandSubtitle,
    required this.bgBrand,
    required this.bgBrandHoverPressed,
    required this.bgPrimary,
    required this.bgPrimaryHoverPressed,
    required this.bgSecondary,
    required this.bgSecondaryHoverPressed,
    required this.bgTertiary,
    required this.bgTertiaryHoverPressed,
    required this.bgDisabled,
    required this.bgDangerSubtitle,
    required this.bgDanger,
    required this.bgDangerBold,
    required this.bgInfoSubtitle,
    required this.bgInfo,
    required this.bgWarningSubtitle,
    required this.bgWarning,
    required this.bgSuccessSubtitle,
    required this.bgSuccess,
    required this.bgInverseBold,
    required this.iconBrand,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconDisabled,
    required this.iconInverse,
    required this.iconDanger,
    required this.iconInfo,
    required this.iconWarning,
    required this.iconSuccess,
    required this.borderBrand,
    required this.borderBrandHoverPressed,
    required this.borderPrimary,
    required this.borderPrimaryHoverPressed,
    required this.borderDisabled,
    required this.borderDangerSubtitle,
    required this.borderDanger,
    required this.borderInfoSubtitle,
    required this.borderInfoBold,
    required this.borderWarningSubtitle,
    required this.borderWarningBold,
    required this.borderSuccessSubtitle,
    required this.borderSuccessBold,
    required this.calendarText,
  });

  @override
  ThemeColorsExt copyWith({
    Color? textBrand,
    Color? textBrandHoverPressed,
    Color? textPrimary,
    Color? textPrimaryHoverPressed,
    Color? textSecondary,
    Color? textSecondaryHoverPressed,
    Color? textTertiary,
    Color? textTertiaryHoverPressed,
    Color? textDisabled,
    Color? textInverse,
    Color? textDanger,
    Color? textDangerBold,
    Color? textInfo,
    Color? textInfoBold,
    Color? textWarning,
    Color? textWarningBold,
    Color? textSuccess,
    Color? textSuccessHoverPressed,
    Color? bgBrandSubtitle,
    Color? bgBrand,
    Color? bgBrandHoverPressed,
    Color? bgPrimary,
    Color? bgPrimaryHoverPressed,
    Color? bgSecondary,
    Color? bgSecondaryHoverPressed,
    Color? bgTertiary,
    Color? bgTertiaryHoverPressed,
    Color? bgDisabled,
    Color? bgDangerSubtitle,
    Color? bgDanger,
    Color? bgDangerBold,
    Color? bgInfoSubtitle,
    Color? bgInfo,
    Color? bgWarningSubtitle,
    Color? bgWarning,
    Color? bgSuccessSubtitle,
    Color? bgSuccess,
    Color? bgInverseBold,
    Color? iconBrand,
    Color? iconBrandHover,
    Color? iconPrimary,
    Color? iconPrimaryHover,
    Color? iconSecondary,
    Color? iconSecondaryHover,
    Color? iconTertiary,
    Color? iconTertiaryHover,
    Color? iconDisabled,
    Color? iconInverse,
    Color? iconDanger,
    Color? iconInfo,
    Color? iconWarning,
    Color? iconSuccess,
    Color? borderBrand,
    Color? borderBrandHoverPressed,
    Color? borderPrimary,
    Color? borderPrimaryHoverPressed,
    Color? borderDisabled,
    Color? borderDangerSubtitle,
    Color? borderDanger,
    Color? borderInfoSubtitle,
    Color? borderInfoBold,
    Color? borderWarningSubtitle,
    Color? borderWarningBold,
    Color? borderSuccessSubtitle,
    Color? borderSuccessBold,
    Color? calendarText,
  }) {
    return ThemeColorsExt(
      textBrand: textBrand ?? this.textBrand,
      textBrandHoverPressed:
          textBrandHoverPressed ?? this.textBrandHoverPressed,
      textPrimary: textPrimary ?? this.textPrimary,
      textPrimaryHoverPressed:
          textPrimaryHoverPressed ?? this.textPrimaryHoverPressed,
      textSecondary: textSecondary ?? this.textSecondary,
      textSecondaryHoverPressed:
          textSecondaryHoverPressed ?? this.textSecondaryHoverPressed,
      textTertiary: textTertiary ?? this.textTertiary,
      textTertiaryHoverPressed:
          textTertiaryHoverPressed ?? this.textTertiaryHoverPressed,
      textDisabled: textDisabled ?? this.textDisabled,
      textInverse: textInverse ?? this.textInverse,
      textDanger: textDanger ?? this.textDanger,
      textDangerBold: textDangerBold ?? this.textDangerBold,
      textInfo: textInfo ?? this.textInfo,
      textInfoBold: textInfoBold ?? this.textInfoBold,
      textWarning: textWarning ?? this.textWarning,
      textWarningBold: textWarningBold ?? this.textWarningBold,
      textSuccess: textSuccess ?? this.textSuccess,
      textSuccessHoverPressed:
          textSuccessHoverPressed ?? this.textSuccessHoverPressed,
      bgBrandSubtitle: bgBrandSubtitle ?? this.bgBrandSubtitle,
      bgBrand: bgBrand ?? this.bgBrand,
      bgBrandHoverPressed: bgBrandHoverPressed ?? this.bgBrandHoverPressed,
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgPrimaryHoverPressed:
          bgPrimaryHoverPressed ?? this.bgPrimaryHoverPressed,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgSecondaryHoverPressed:
          bgSecondaryHoverPressed ?? this.bgSecondaryHoverPressed,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      bgTertiaryHoverPressed:
          bgTertiaryHoverPressed ?? this.bgTertiaryHoverPressed,
      bgDisabled: bgDisabled ?? this.bgDisabled,
      bgDangerSubtitle: bgDangerSubtitle ?? this.bgDangerSubtitle,
      bgDanger: bgDanger ?? this.bgDanger,
      bgDangerBold: bgDangerBold ?? this.bgDangerBold,
      bgInfoSubtitle: bgInfoSubtitle ?? this.bgInfoSubtitle,
      bgInfo: bgInfo ?? this.bgInfo,
      bgWarningSubtitle: bgWarningSubtitle ?? this.bgWarningSubtitle,
      bgWarning: bgWarning ?? this.bgWarning,
      bgSuccessSubtitle: bgSuccessSubtitle ?? this.bgSuccessSubtitle,
      bgSuccess: bgSuccess ?? this.bgSuccess,
      bgInverseBold: bgInverseBold ?? this.bgInverseBold,
      iconBrand: iconBrand ?? this.iconBrand,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconTertiary: iconTertiary ?? this.iconTertiary,
      iconDisabled: iconDisabled ?? this.iconDisabled,
      iconInverse: iconInverse ?? this.iconInverse,
      iconDanger: iconDanger ?? this.iconDanger,
      iconInfo: iconInfo ?? this.iconInfo,
      iconWarning: iconWarning ?? this.iconWarning,
      iconSuccess: iconSuccess ?? this.iconSuccess,
      borderBrand: borderBrand ?? this.borderBrand,
      borderBrandHoverPressed:
          borderBrandHoverPressed ?? this.borderBrandHoverPressed,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderPrimaryHoverPressed:
          borderPrimaryHoverPressed ?? this.borderPrimaryHoverPressed,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      borderDangerSubtitle: borderDangerSubtitle ?? this.borderDangerSubtitle,
      borderDanger: borderDanger ?? this.borderDanger,
      borderInfoSubtitle: borderInfoSubtitle ?? this.borderInfoSubtitle,
      borderInfoBold: borderInfoBold ?? this.borderInfoBold,
      borderWarningSubtitle:
          borderWarningSubtitle ?? this.borderWarningSubtitle,
      borderWarningBold: borderWarningBold ?? this.borderWarningBold,
      borderSuccessSubtitle:
          borderSuccessSubtitle ?? this.borderSuccessSubtitle,
      borderSuccessBold: borderSuccessBold ?? this.borderSuccessBold,
      calendarText: calendarText ?? this.calendarText,
    );
  }

  @override
  ThemeColorsExt lerp(ThemeExtension<ThemeColorsExt>? other, double t) {
    if (other is! ThemeColorsExt) return this;
    return ThemeColorsExt(
      textBrand: Color.lerp(textBrand, other.textBrand, t) ??
          ThemeColorHue.textBrand.light,
      textBrandHoverPressed:
          Color.lerp(textBrandHoverPressed, other.textBrandHoverPressed, t) ??
              ThemeColorHue.textBrandHoverPressed.light,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ??
          ThemeColorHue.textPrimary.light,
      textPrimaryHoverPressed: Color.lerp(
              textPrimaryHoverPressed, other.textPrimaryHoverPressed, t) ??
          ThemeColorHue.textPrimaryHoverPressed.light,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t) ??
          ThemeColorHue.textSecondary.light,
      textSecondaryHoverPressed: Color.lerp(
              textSecondaryHoverPressed, other.textSecondaryHoverPressed, t) ??
          ThemeColorHue.textSecondaryHoverPressed.light,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t) ??
          ThemeColorHue.textTertiary.light,
      textTertiaryHoverPressed: Color.lerp(
              textTertiaryHoverPressed, other.textTertiaryHoverPressed, t) ??
          ThemeColorHue.textTertiaryHoverPressed.light,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t) ??
          ThemeColorHue.textDisabled.light,
      textInverse: Color.lerp(textInverse, other.textInverse, t) ??
          ThemeColorHue.textInverse.light,
      textDanger: Color.lerp(textDanger, other.textDanger, t) ??
          ThemeColorHue.textDanger.light,
      textDangerBold: Color.lerp(textDangerBold, other.textDangerBold, t) ??
          ThemeColorHue.textDangerBold.light,
      textInfo: Color.lerp(textInfo, other.textInfo, t) ??
          ThemeColorHue.textInfo.light,
      textInfoBold: Color.lerp(textInfoBold, other.textInfoBold, t) ??
          ThemeColorHue.textInfoBold.light,
      textWarning: Color.lerp(textWarning, other.textWarning, t) ??
          ThemeColorHue.textWarning.light,
      textWarningBold: Color.lerp(textWarningBold, other.textWarningBold, t) ??
          ThemeColorHue.textWarningBold.light,
      textSuccess: Color.lerp(textSuccess, other.textSuccess, t) ??
          ThemeColorHue.textSuccess.light,
      textSuccessHoverPressed: Color.lerp(
              textSuccessHoverPressed, other.textSuccessHoverPressed, t) ??
          ThemeColorHue.textSuccessHoverPressed.light,
      bgBrandSubtitle: Color.lerp(bgBrandSubtitle, other.bgBrandSubtitle, t) ??
          ThemeColorHue.bgBrandSubtitle.light,
      bgBrand:
          Color.lerp(bgBrand, other.bgBrand, t) ?? ThemeColorHue.bgBrand.light,
      bgBrandHoverPressed:
          Color.lerp(bgBrandHoverPressed, other.bgBrandHoverPressed, t) ??
              ThemeColorHue.bgBrandHoverPressed.light,
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t) ??
          ThemeColorHue.bgPrimary.light,
      bgPrimaryHoverPressed:
          Color.lerp(bgPrimaryHoverPressed, other.bgPrimaryHoverPressed, t) ??
              ThemeColorHue.bgPrimaryHoverPressed.light,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t) ??
          ThemeColorHue.bgSecondary.light,
      bgSecondaryHoverPressed: Color.lerp(
              bgSecondaryHoverPressed, other.bgSecondaryHoverPressed, t) ??
          ThemeColorHue.bgSecondaryHoverPressed.light,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t) ??
          ThemeColorHue.bgTertiary.light,
      bgTertiaryHoverPressed:
          Color.lerp(bgTertiaryHoverPressed, other.bgTertiaryHoverPressed, t) ??
              ThemeColorHue.bgTertiaryHoverPressed.light,
      bgDisabled: Color.lerp(bgDisabled, other.bgDisabled, t) ??
          ThemeColorHue.bgDisabled.light,
      bgDangerSubtitle:
          Color.lerp(bgDangerSubtitle, other.bgDangerSubtitle, t) ??
              ThemeColorHue.bgDangerSubtitle.light,
      bgDanger: Color.lerp(bgDanger, other.bgDanger, t) ??
          ThemeColorHue.bgDanger.light,
      bgDangerBold: Color.lerp(bgDangerBold, other.bgDangerBold, t) ??
          ThemeColorHue.bgDangerBold.light,
      bgInfoSubtitle: Color.lerp(bgInfoSubtitle, other.bgInfoSubtitle, t) ??
          ThemeColorHue.bgInfoSubtitle.light,
      bgInfo:
          Color.lerp(bgInfo, other.bgInfo, t) ?? ThemeColorHue.bgInfoBold.light,
      bgWarningSubtitle:
          Color.lerp(bgWarningSubtitle, other.bgWarningSubtitle, t) ??
              ThemeColorHue.bgWarningSubtitle.light,
      bgWarning: Color.lerp(bgWarning, other.bgWarning, t) ??
          ThemeColorHue.bgWarningBold.light,
      bgSuccessSubtitle:
          Color.lerp(bgSuccessSubtitle, other.bgSuccessSubtitle, t) ??
              ThemeColorHue.bgSuccessSubtitle.light,
      bgSuccess: Color.lerp(bgSuccess, other.bgSuccess, t) ??
          ThemeColorHue.bgSuccessBold.light,
      bgInverseBold: Color.lerp(bgInverseBold, other.bgInverseBold, t) ??
          ThemeColorHue.bgInverseBold.light,
      iconBrand: Color.lerp(iconBrand, other.iconBrand, t) ??
          ThemeColorHue.iconBrand.light,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t) ??
          ThemeColorHue.iconPrimary.light,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t) ??
          ThemeColorHue.iconSecondary.light,
      iconTertiary: Color.lerp(iconTertiary, other.iconTertiary, t) ??
          ThemeColorHue.iconTertiary.light,
      iconDisabled: Color.lerp(iconDisabled, other.iconDisabled, t) ??
          ThemeColorHue.iconDisabled.light,
      iconInverse: Color.lerp(iconInverse, other.iconInverse, t) ??
          ThemeColorHue.iconInverse.light,
      iconDanger: Color.lerp(iconDanger, other.iconDanger, t) ??
          ThemeColorHue.iconDanger.light,
      iconInfo: Color.lerp(iconInfo, other.iconInfo, t) ??
          ThemeColorHue.iconInfo.light,
      iconWarning: Color.lerp(iconWarning, other.iconWarning, t) ??
          ThemeColorHue.iconWarning.light,
      iconSuccess: Color.lerp(iconSuccess, other.iconSuccess, t) ??
          ThemeColorHue.iconSuccess.light,
      borderBrand: Color.lerp(borderBrand, other.borderBrand, t) ??
          ThemeColorHue.borderBrand.light,
      borderBrandHoverPressed: Color.lerp(
              borderBrandHoverPressed, other.borderBrandHoverPressed, t) ??
          ThemeColorHue.borderBrandHoverPressed.light,
      borderPrimary: Color.lerp(borderPrimary, other.borderPrimary, t) ??
          ThemeColorHue.borderPrimary.light,
      borderPrimaryHoverPressed: Color.lerp(
              borderPrimaryHoverPressed, other.borderPrimaryHoverPressed, t) ??
          ThemeColorHue.borderPrimaryHoverPressed.light,
      borderDisabled: Color.lerp(borderDisabled, other.borderDisabled, t) ??
          ThemeColorHue.borderDisabled.light,
      borderDangerSubtitle:
          Color.lerp(borderDangerSubtitle, other.borderDangerSubtitle, t) ??
              ThemeColorHue.borderDangerSubtitle.light,
      borderDanger: Color.lerp(borderDanger, other.borderDanger, t) ??
          ThemeColorHue.borderDanger.light,
      borderInfoSubtitle:
          Color.lerp(borderInfoSubtitle, other.borderInfoSubtitle, t) ??
              ThemeColorHue.borderInfoSubtitle.light,
      borderInfoBold: Color.lerp(borderInfoBold, other.borderInfoBold, t) ??
          ThemeColorHue.borderInfoBold.light,
      borderWarningSubtitle:
          Color.lerp(borderWarningSubtitle, other.borderWarningSubtitle, t) ??
              ThemeColorHue.borderWarningSubtitle.light,
      borderWarningBold:
          Color.lerp(borderWarningBold, other.borderWarningBold, t) ??
              ThemeColorHue.borderWarningBold.light,
      borderSuccessSubtitle:
          Color.lerp(borderSuccessSubtitle, other.borderSuccessSubtitle, t) ??
              ThemeColorHue.borderSuccessSubtitle.light,
      borderSuccessBold:
          Color.lerp(borderSuccessBold, other.borderSuccessBold, t) ??
              ThemeColorHue.borderSuccessBold.light,
      calendarText: Color.lerp(calendarText, other.calendarText, t) ??
          ThemeColorHue.calendarText.light,
    );
  }
}

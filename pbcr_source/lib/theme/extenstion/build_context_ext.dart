import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/custom_color_theme_extension.dart';

extension ThemeColorExt on BuildContext {
  Color get textBrand => Theme.of(this).extension<ThemeColorsExt>()!.textBrand;
  Color get textBrandHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.textBrandHoverPressed;
  Color get textPrimary =>
      Theme.of(this).extension<ThemeColorsExt>()!.textPrimary;
  Color get textPrimaryHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.textPrimaryHoverPressed;
  Color get textSecondary =>
      Theme.of(this).extension<ThemeColorsExt>()!.textSecondary;
  Color get textSecondaryHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.textSecondaryHoverPressed;
  Color get textTertiary =>
      Theme.of(this).extension<ThemeColorsExt>()!.textTertiary;
  Color get textTertiaryHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.textTertiaryHoverPressed;
  Color get textDisabled =>
      Theme.of(this).extension<ThemeColorsExt>()!.textDisabled;
  Color get textInverse =>
      Theme.of(this).extension<ThemeColorsExt>()!.textInverse;
  Color get textDanger =>
      Theme.of(this).extension<ThemeColorsExt>()!.textDanger;
  Color get textDangerBold =>
      Theme.of(this).extension<ThemeColorsExt>()!.textDangerBold;
  Color get textInfo => Theme.of(this).extension<ThemeColorsExt>()!.textInfo;
  Color get textInfoBold =>
      Theme.of(this).extension<ThemeColorsExt>()!.textInfoBold;
  Color get textWarning =>
      Theme.of(this).extension<ThemeColorsExt>()!.textWarning;
  Color get textWarningBold =>
      Theme.of(this).extension<ThemeColorsExt>()!.textWarningBold;
  Color get textSuccess =>
      Theme.of(this).extension<ThemeColorsExt>()!.textSuccess;
  Color get textSuccessHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.textSuccessHoverPressed;
  Color get bgBrandSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgBrandSubtitle;
  Color get bgBrand => Theme.of(this).extension<ThemeColorsExt>()!.bgBrand;
  Color get bgBrandHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgBrandHoverPressed;
  Color get bgPrimary => Theme.of(this).extension<ThemeColorsExt>()!.bgPrimary;
  Color get bgPrimaryHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgPrimaryHoverPressed;
  Color get bgSecondary =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgSecondary;
  Color get bgSecondaryHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgSecondaryHoverPressed;
  Color get bgTertiary =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgTertiary;
  Color get bgTertiaryHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgTertiaryHoverPressed;
  Color get bgDisabled =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgDisabled;
  Color get bgDangerSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgDangerSubtitle;
  Color get bgDanger => Theme.of(this).extension<ThemeColorsExt>()!.bgDanger;
  Color get bgDangerBold =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgDangerBold;
  Color get bgInfoSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgInfoSubtitle;
  Color get bgInfo => Theme.of(this).extension<ThemeColorsExt>()!.bgInfo;
  Color get bgWarningSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgWarningSubtitle;
  Color get bgWarning => Theme.of(this).extension<ThemeColorsExt>()!.bgWarning;
  Color get bgSuccessSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgSuccessSubtitle;
  Color get bgSuccess => Theme.of(this).extension<ThemeColorsExt>()!.bgSuccess;
  Color get bgInverseBold =>
      Theme.of(this).extension<ThemeColorsExt>()!.bgInverseBold;
  Color get iconBrand => Theme.of(this).extension<ThemeColorsExt>()!.iconBrand;
  Color get iconPrimary =>
      Theme.of(this).extension<ThemeColorsExt>()!.iconPrimary;
  Color get iconSecondary =>
      Theme.of(this).extension<ThemeColorsExt>()!.iconSecondary;
  Color get iconTertiary =>
      Theme.of(this).extension<ThemeColorsExt>()!.iconTertiary;
  Color get iconDisabled =>
      Theme.of(this).extension<ThemeColorsExt>()!.iconDisabled;
  Color get iconInverse =>
      Theme.of(this).extension<ThemeColorsExt>()!.iconInverse;
  Color get iconDanger =>
      Theme.of(this).extension<ThemeColorsExt>()!.iconDanger;
  Color get iconInfo => Theme.of(this).extension<ThemeColorsExt>()!.iconInfo;
  Color get iconWarning =>
      Theme.of(this).extension<ThemeColorsExt>()!.iconWarning;
  Color get iconSuccess =>
      Theme.of(this).extension<ThemeColorsExt>()!.iconSuccess;
  Color get borderBrand =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderBrand;
  Color get borderBrandHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderBrandHoverPressed;
  Color get borderPrimary =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderPrimary;
  Color get borderPrimaryHoverPressed =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderPrimaryHoverPressed;
  Color get borderDisabled =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderDisabled;
  Color get borderDangerSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderDangerSubtitle;
  Color get borderDanger =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderDanger;
  Color get borderInfoSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderInfoSubtitle;
  Color get borderInfoBold =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderInfoBold;
  Color get borderWarningSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderWarningSubtitle;
  Color get borderWarningBold =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderWarningBold;
  Color get borderSuccessSubtitle =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderSuccessSubtitle;
  Color get borderSuccessBold =>
      Theme.of(this).extension<ThemeColorsExt>()!.borderSuccessBold;

  Color get calendarText =>
      Theme.of(this).extension<ThemeColorsExt>()!.calendarText;
}

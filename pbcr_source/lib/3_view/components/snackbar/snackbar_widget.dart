import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

enum SnackBarType { info, success, error, warning }

extension SnackBarTypeExt on SnackBarType {
  Color backgroundColor(BuildContext context) {
    switch (this) {
      case SnackBarType.info:
        return context.bgInfoSubtitle;
      case SnackBarType.success:
        return context.bgSuccessSubtitle;
      case SnackBarType.error:
        return context.bgDangerSubtitle;
      case SnackBarType.warning:
        return context.bgWarningSubtitle;
    }
  }

  String get svgPath {
    switch (this) {
      case SnackBarType.info:
        return SvgIcons.infoFilled.svgPath;
      case SnackBarType.success:
        return SvgIcons.checkRoundFilled.svgPath;
      case SnackBarType.error:
        return SvgIcons.reportFilled.svgPath;
      case SnackBarType.warning:
        return SvgIcons.warningFilled.svgPath;
    }
  }
}

class SnackBarWidget extends StatelessWidget {
  final SnackBarType type;
  final Widget? prefix;
  final String title;
  final String? subText;
  final TextStyle? titleStyle;
  final TextStyle? subTextStyle;
  final Widget? actionIcon;
  final bool showCloseIcon;

  const SnackBarWidget({
    super.key,
    required this.type,
    this.prefix,
    required this.title,
    this.subText,
    this.titleStyle,
    this.subTextStyle,
    this.actionIcon,
    this.showCloseIcon = true,
  });

  void closeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: type.backgroundColor(context),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefix ?? snackBarIcon(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: titleStyle ?? TextStyles.body2.medium,
                      ),
                    ),
                    if (showCloseIcon || actionIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: actionIcon ?? closeIcon(context),
                      ),
                  ],
                ),
                if (subText != null && subText!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subText ?? '',
                      style: subTextStyle ??
                          TextStyles.caption2.secondaryColor(context),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget snackBarIcon() {
    return SvgPicture.asset(
      type.svgPath,
      width: 24,
      height: 24,
    );
  }

  Widget closeIcon(BuildContext context) {
    return GestureDetector(
      onTap: () => closeSnackBar(context),
      child: SvgPicture.asset(
        SvgIcons.cancel.svgPath,
        width: 20,
        height: 20,
      ),
    );
  }
}

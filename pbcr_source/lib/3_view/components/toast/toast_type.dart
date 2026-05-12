import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';

enum ToastType { info, success, error }

extension ToastTypeExt on ToastType {
  String get svgPath {
    switch (this) {
      case ToastType.info:
        return SvgIcons.infoFilled.svgPath;
      case ToastType.success:
        return SvgIcons.checkRoundFilled.svgPath;
      case ToastType.error:
        return SvgIcons.reportFilled.svgPath;
    }
  }
}
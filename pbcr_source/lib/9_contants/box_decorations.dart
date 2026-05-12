import 'package:flutter/widgets.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class BoxDecorations {
  static BoxDecoration borderBox(
    BuildContext context, {
    Color? color,
    Color? borderColor,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
  }) =>
      BoxDecoration(
        border: Border.all(
          color: borderColor ?? context.borderPrimary,
          width: borderWidth ?? 1,
        ),
        borderRadius: borderRadius,
        color: color,
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icreat_dct/3_view/components/constants/box_shadows.dart';
import 'package:icreat_dct/3_view/components/toast/toast_type.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class ToastWidget extends StatelessWidget {
  const ToastWidget({
    super.key,
    required this.type,
    required this.message,
    this.msgTextStyle,
  });

  final ToastType type;
  final String message;
  final TextStyle? msgTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: context.textPrimary,
        boxShadow: BoxShadows.shadow2,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            type.svgPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style:
                  msgTextStyle ?? TextStyles.body2.medium.inverseColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

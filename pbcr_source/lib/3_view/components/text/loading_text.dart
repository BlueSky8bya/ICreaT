import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class LoadingText extends StatelessWidget {
  const LoadingText({
    super.key,
    required this.text,
    this.style,
    this.loadingCircleSize,
  });

  final String text;
  final TextStyle? style;
  final double? loadingCircleSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: style ?? TextStyles.headline3,
        ),
        const SizedBox(width: 16),
        LoadingBouncingLine.circle(
          backgroundColor: context.bgBrand,
          size: loadingCircleSize ?? 40,
        )
      ],
    );
  }
}

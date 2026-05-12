import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/custom_inkwell.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class RoundedCard extends StatelessWidget {
  final Color backgroundColor;
  final EdgeInsets padding;
  final EdgeInsets margin;

  final Widget child;
  final VoidCallback? onTap;

  const RoundedCard({
    super.key,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.margin = const EdgeInsets.all(0),
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = 16.0;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: context.borderPrimary,
        ),
      ),
      margin: margin,
      child: CustomInkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

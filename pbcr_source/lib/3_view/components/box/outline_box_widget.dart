import 'package:flutter/widgets.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class OutlineBoxWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? padding;

  final VoidCallback? onTap;

  final Widget child;

  const OutlineBoxWidget({
    super.key,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? context.bgPrimary,
          border: Border.all(
            color: borderColor ?? context.borderPrimary,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}

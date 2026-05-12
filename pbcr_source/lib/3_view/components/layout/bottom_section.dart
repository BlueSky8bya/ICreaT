import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

enum BottomSectionStyle {
  none,
  line;

  BoxDecoration decoration(BuildContext context) {
    switch (this) {
      case BottomSectionStyle.none:
        return BoxDecoration();
      case BottomSectionStyle.line:
        return BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.borderPrimary,
            ),
          ),
        );
    }
  }
}

class BottomSection extends StatelessWidget {
  final BottomSectionStyle style;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final bool isHorizontal;

  const BottomSection({
    super.key,
    this.style = BottomSectionStyle.line,
    required this.children,
    this.padding,
    this.spacing = 16,
    this.isHorizontal = false,
  });

  static EdgeInsetsGeometry defaultPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
      16,
      16,
      16,
      16 + MediaQuery.of(context).viewInsets.bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: style.decoration(context),
      padding: padding ?? defaultPadding(context),
      duration: const Duration(milliseconds: 150),
      child: isHorizontal
          ? Row(
              spacing: spacing,
              children: children.map((e) => Expanded(child: e)).toList(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: spacing,
              children: children,
            ),
    );
  }
}

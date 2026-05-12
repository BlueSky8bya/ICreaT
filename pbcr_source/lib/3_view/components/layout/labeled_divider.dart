import 'package:flutter/material.dart';

class LabeledDivider extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final Color? dividerColor;

  const LabeledDivider({
    super.key,
    required this.label,
    this.labelStyle,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
          ),
        ),
        Text(label, style: labelStyle),
        Expanded(
          child: Divider(color: dividerColor),
        ),
      ],
    );
  }
}

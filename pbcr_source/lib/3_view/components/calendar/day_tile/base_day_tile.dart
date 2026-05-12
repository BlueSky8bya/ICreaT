import 'package:flutter/material.dart';

abstract class BaseDayTile extends StatelessWidget {
  final DateTime day;
  final TextStyle? textStyle;

  final VoidCallback? onTap;

  const BaseDayTile({
    super.key,
    required this.day,
    this.textStyle,
    this.onTap,
  });

  TextStyle? themedTextStyle(BuildContext context) =>
      textStyle ?? Theme.of(context).textTheme.bodyLarge;
}

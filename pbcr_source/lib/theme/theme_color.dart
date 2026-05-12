import 'package:flutter/material.dart';

class ThemeColor {
  final Color light;
  final Color dark;

  const ThemeColor({
    required this.light,
    required this.dark,
  });

  Color getColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}

import 'package:flutter/material.dart';

class TextWidgetUtil {
  TextWidgetUtil._();

  static double getMinTextWidth({
    required List<String> texts,
    required TextStyle style,
  }) =>
      texts
          .map((text) => getTextWidth(text: text, style: style))
          .reduce((a, b) => a > b ? b : a);
  

  static double getMaxTextWidth({
    required List<String> texts,
    required TextStyle style,
  }) =>
      texts
          .map((text) => getTextWidth(text: text, style: style))
          .reduce((a, b) => a > b ? a : b);

  static double getTextWidth({
    required String text,
    required TextStyle style,
  }) {
    final textSpan = TextSpan(text: text, style: style);

    final tp = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return tp.size.width;
  }

  static double getTextHeight({
    required String text,
    required TextStyle style,
    required double screenWidth,
  }) {
    if (text.isEmpty) return 0;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    int numberOfLine = textPainter.width ~/ screenWidth;

    return textPainter.height * (numberOfLine + 1);
  }
}

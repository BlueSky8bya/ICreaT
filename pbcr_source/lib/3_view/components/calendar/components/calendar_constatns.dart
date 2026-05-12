import 'dart:math';

import 'package:flutter/material.dart';
import 'package:icreat_dct/6_util/text_widget_util.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class CalendarConstants {
  static const calendarTileIconSize = 12.0;
  static const calendarTileGap = 2.0;

  static EdgeInsets calendarTilePadding =
      const EdgeInsets.symmetric(vertical: 8);

  static TextStyle smallDayTextStyle =
      TextStyles.caption2.semiBold.copyWith(height: 1.0);

  static TextStyle mediumDayTextStyle =
      TextStyles.body2.medium.copyWith(height: 1.0);

  static double calendarTileDayHeight =
      TextWidgetUtil.getTextWidth(text: '00', style: smallDayTextStyle) + 4;

  static TextStyle calendarTileWeightTextStyle(BuildContext context) {
    return TextStyles.caption1.medium.primaryColor(context);
  }

  /// 정사각형 타일 크기 계산
  static double squareTileHeight(
    BuildContext context, {
    // 1줄에 표시되는 날짜 개수
    int dayCount = 7,
    // 양 옆 패딩
    double padding = 16,
  }) {
    final minSize = calendarTileDayHeight;

    final width = MediaQuery.of(context).size.width - padding * 2;
    final tileSize = width / dayCount;

    return max(minSize, tileSize);
  }

  /// 직사각형 타일 크기 계산
  static double rectangleTileHeight(BuildContext context) {
    final subTextHeight = TextWidgetUtil.getTextHeight(
      text: 'a',
      style: calendarTileWeightTextStyle(context),
      screenWidth: MediaQuery.of(context).size.width,
    );

    return calendarTileDayHeight +
        subTextHeight +
        calendarTileIconSize +
        calendarTilePadding.vertical +
        (calendarTileGap * 2);
  }
}

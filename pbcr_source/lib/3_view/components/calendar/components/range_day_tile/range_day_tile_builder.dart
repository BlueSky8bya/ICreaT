import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/opacity_widget_button.dart';
import 'package:icreat_dct/3_view/components/calendar/components/calendar_constatns.dart';
import 'package:icreat_dct/3_view/components/calendar/data/range_marker_type.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';

abstract class RangeDayTileBuilder {
  Widget build(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
    RangeMarkerType markerType, {
    Function(DateTime)? onTap,
    Function(DateTime)? onDoubleTap,
  });
}

/// 단일 날짜일 때는 원형 여러 날짜인 경우 양쪽 끝만 둥근 모양
class BandRangeDayTileBuilder implements RangeDayTileBuilder {
  const BandRangeDayTileBuilder({
    this.padding = 6.0,
    this.bandColor,
    this.bandDayTextColor,
    this.selectedBoxColor,
    this.selectedTextColor,
  });

  final double padding;
  final Color? bandColor;
  final Color? selectedBoxColor;
  final Color? bandDayTextColor;
  final Color? selectedTextColor;

  EdgeInsets _paddingByMarker(RangeMarkerType rangeMarker) {
    return EdgeInsets.symmetric(
      vertical: padding,
    ).copyWith(
      left: rangeMarker == RangeMarkerType.start ? padding : 0,
      right: rangeMarker == RangeMarkerType.end ? padding : 0,
    );
  }

  BorderRadiusGeometry _borderRadius(RangeMarkerType rangeMarker) {
    switch (rangeMarker) {
      case RangeMarkerType.start:
        return const BorderRadius.horizontal(
          left: Radius.circular(1000),
        );
      case RangeMarkerType.end:
        return const BorderRadius.horizontal(
          right: Radius.circular(1000),
        );
      case RangeMarkerType.middle:
        return BorderRadius.zero;
      case RangeMarkerType.single:
        return BorderRadius.circular(1000);
    }
  }

  BoxShape _boxShape(RangeMarkerType rangeMarker) {
    switch (rangeMarker) {
      case RangeMarkerType.start:
        return BoxShape.rectangle;
      case RangeMarkerType.end:
        return BoxShape.rectangle;
      case RangeMarkerType.middle:
        return BoxShape.rectangle;
      case RangeMarkerType.single:
        return BoxShape.circle;
    }
  }

  Color _bandColor(BuildContext context) => bandColor ?? context.bgSecondary;

  TextStyle _textStyle(BuildContext context) {
    return CalendarConstants.mediumDayTextStyle.calendarTextColor(context);
  }

  double _rotateAngle(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl ? math.pi : 0;

  @override
  Widget build(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
    RangeMarkerType markerType, {
    Function(DateTime)? onTap,
    Function(DateTime)? onDoubleTap,
  }) {
    return OpacityWidgetButton.noDebounce(
      onTap: (_) => onTap?.call(day),
      child: Stack(
        children: [
          Transform.rotate(
            angle: _rotateAngle(context),
            child: Padding(
              padding: _paddingByMarker(markerType),
              child: ClipRRect(
                borderRadius: _borderRadius(markerType),
                child: Container(
                  decoration: BoxDecoration(
                    color: _bandColor(context),
                    shape: _boxShape(markerType),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              '${day.day}',
              style: _textStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}

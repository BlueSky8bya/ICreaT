import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/calendar/components/calendar_constatns.dart';

enum DayTileSize {
  square,
  rectangle,
  ;

  double calculateHeight(BuildContext context) {
    switch (this) {
      case DayTileSize.square:
        return CalendarConstants.squareTileHeight(context);
      case DayTileSize.rectangle:
        return CalendarConstants.rectangleTileHeight(context);
    }
  }
}

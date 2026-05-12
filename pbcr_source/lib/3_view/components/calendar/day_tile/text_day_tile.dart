import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/custom_inkwell.dart';
import 'package:icreat_dct/3_view/components/calendar/day_tile/base_day_tile.dart';

class TextDayTile extends BaseDayTile {
  const TextDayTile({
    super.key,
    required super.day,
    super.textStyle,
    super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomInkWell(
        onTap: onTap,
        isCircle: true,
        child: Center(
          child: Text(
            day.day.toString(),
            style: themedTextStyle(context),
          ),
        ),
      ),
    );
  }
}

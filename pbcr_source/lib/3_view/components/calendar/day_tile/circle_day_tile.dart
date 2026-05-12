import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/custom_inkwell.dart';
import 'package:icreat_dct/3_view/components/calendar/day_tile/base_day_tile.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class CircleDayTile extends BaseDayTile {
  final Color color;

  const CircleDayTile({
    super.key,
    required super.day,
    super.textStyle,
    super.onTap,
    required this.color,
  });

  factory CircleDayTile.themePrimary(
    BuildContext context, {
    Key? key,
    required DateTime day,
    Color? color,
    TextStyle? textStyle,
    VoidCallback? onTap,
  }) {
    return CircleDayTile(
      key: key,
      day: day,
      textStyle: textStyle,
      color: context.bgSecondary,
    );
  }

  @override
  TextStyle themedTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: context.calendarText,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomInkWell(
        onTap: onTap,
        isCircle: true,
        child: LayoutBuilder(builder: (context, constraints) {
          final diameter = constraints.maxWidth * 0.75;

          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: diameter,
                  height: diameter,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: themedTextStyle(context),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

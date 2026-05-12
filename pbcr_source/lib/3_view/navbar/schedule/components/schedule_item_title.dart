import 'package:flutter/material.dart';

import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';
import 'package:icreat_dct/3_view/components/badge/category_tag.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class ScheduleItemTile extends StatelessWidget {
  final ScheduleItemModel schedule;
  final void Function(ScheduleItemModel schedule) onTap;

  const ScheduleItemTile({
    super.key,
    required this.schedule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.borderPrimary,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(schedule),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                CategoryTag(
                  text: schedule.status.label,
                  color: schedule.status.badgeColor,
                ),
                Text(
                  schedule.formName,
                  style: TextStyles.body1.semiBold.primaryColor(context),
                ),
                Text(
                  schedule.plannedDate.toKoreanYMD(),
                  style: TextStyles.body2.secondaryColor(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

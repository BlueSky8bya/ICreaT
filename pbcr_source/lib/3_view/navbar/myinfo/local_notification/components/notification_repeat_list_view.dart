import 'package:flutter/material.dart';
import 'package:icreat_dct/0_data/model/local_notification/week_day.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class WeekDayRepeatSelector extends StatelessWidget {
  final Set<WeekDay> selectedWeekDays;

  final void Function(WeekDay weekDay) onTapWeekDay;

  const WeekDayRepeatSelector({
    super.key,
    required this.selectedWeekDays,
    required this.onTapWeekDay,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: WeekDay.values.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _WeekDayCard(
        weekDay: WeekDay.values[index],
        isSelected: selectedWeekDays.contains(WeekDay.values[index]),
        onTap: () => onTapWeekDay(WeekDay.values[index]),
      ),
    );
  }
}

class _WeekDayCard extends StatelessWidget {
  final WeekDay weekDay;
  final bool isSelected;
  final void Function() onTap;

  const _WeekDayCard({
    required this.weekDay,
    required this.isSelected,
    required this.onTap,
  });

  BoxDecoration _boxDecoration(BuildContext context) {
    if (isSelected) {
      return BoxDecoration(
        color: context.bgBrandSubtitle,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.borderBrand,
        ),
      );
    }
    return BoxDecoration(
      color: context.bgPrimary,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: context.borderPrimary,
      ),
    );
  }

  TextStyle _textStyle(BuildContext context) {
    if (isSelected) {
      return TextStyles.body2.medium.primaryColor(context);
    }
    return TextStyles.body2.medium.primaryColor(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: _boxDecoration(context),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            weekDay.name,
            style: _textStyle(context),
          ),
        ),
      ),
    );
  }
}

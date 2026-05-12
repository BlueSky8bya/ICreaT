import 'package:flutter/widgets.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/3_view/components/rounded_card.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class DailyStepCard extends StatelessWidget {
  final DailyStepRecord stepRecord;
  final VoidCallback? onTap;

  const DailyStepCard({
    super.key,
    required this.stepRecord,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text('걸음 수', style: TextStyles.body2),
          Text(
            "${stepRecord.totalStepCount} 걸음",
            style: TextStyles.body1.semiBold,
          ),
        ],
      ),
    );
  }
}

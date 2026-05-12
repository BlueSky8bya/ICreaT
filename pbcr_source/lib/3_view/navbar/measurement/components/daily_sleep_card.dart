import 'package:flutter/widgets.dart';
import 'package:icreat_dct/0_data/model/health/daily_sleep_record.dart';
import 'package:icreat_dct/3_view/components/rounded_card.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class DailySleepCard extends StatelessWidget {
  final DailySleepRecord dailySleepRecord;
  final VoidCallback? onTap;

  const DailySleepCard({
    super.key,
    required this.dailySleepRecord,
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
          Text('총 수면 시간', style: TextStyles.body2),
          Text(
            dailySleepRecord.format(),
            style: TextStyles.body1.semiBold,
          ),
        ],
      ),
    );
  }
}

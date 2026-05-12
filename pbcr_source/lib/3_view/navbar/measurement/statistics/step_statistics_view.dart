import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/box/shadow_box_widget.dart';
import 'package:icreat_dct/3_view/components/button/segmented_switch_button.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/wrapper/bouncing_scroll_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/1_data/stats_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/3_view/step_bar_graph_widget.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/step_statistics_view_model.dart';
import 'package:icreat_dct/6_util/text_formatter.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class StepStatisticsView extends GetView<StepStatisticsViewModel> {
  const StepStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: CommonAppBar(
        title: Text(
          '걸음 통계',
          style: TextStyles.body1.semiBold.primaryColor(context),
        ),
      ),
      backgroundColor: context.bgPrimary,
      child: BouncingScrollView(
        child: Column(
          children: [
            _StatisticsSectionCard(viewModel: controller),
            Divider(
              color: context.bgPrimaryHoverPressed,
              thickness: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Obx(
                () => _DailyStepSectionCard(
                  stepRecord: controller.todayStepRecord,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyStepSectionCard extends StatelessWidget {
  final DailyStepRecord stepRecord;

  const _DailyStepSectionCard({
    required this.stepRecord,
  });

  int get totalStepCount => stepRecord.totalStepCount;

  @override
  Widget build(BuildContext context) {
    return ShadowBoxWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '오늘의 걸음 수',
            style: TextStyles.body2.tertiaryColor(context),
          ),
          Text(
            '${TextFormatter.insertComma(totalStepCount)} 걸음',
            style: TextStyles.headline2.semiBold.primaryColor(context),
          ),
        ],
      ),
    );
  }
}

class _StatisticsSectionCard extends StatelessWidget {
  final StepStatisticsViewModel viewModel;

  const _StatisticsSectionCard({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.bgPrimary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            SegmentedSwitchButton(
              items: StatsType.values,
              onValueChanged: (value) {
                viewModel.handleStatsTypeChanged(value);
              },
              textTransformer: (context, value) {
                return (value.label);
              },
            ),
            StepBarGraphWidget(
              stepChartManager: viewModel.stepChartManager,
            ),
          ],
        ),
      ),
    );
  }
}

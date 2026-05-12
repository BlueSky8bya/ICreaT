import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/navbar/measurement/statistics/8_utils/step_graph_manager.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class StepBarGraphWidget extends StatelessWidget {
  final StepGraphManager stepChartManager;

  const StepBarGraphWidget({
    super.key,
    required this.stepChartManager,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Obx(
        () {
          return BarChart(
            BarChartData(
              barTouchData: barTouchData(context),
              titlesData: titlesData(context),
              borderData: borderData,
              barGroups: makeBarGroups(context),
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: stepChartManager.maxY.toDouble(),
            ),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> makeBarGroups(
    BuildContext context,
  ) {
    return stepChartManager.aggregatedStepRecords.entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.avgStepCount.toDouble(),
            color: context.bgBrand,
          ),
        ],
      );
    }).toList();
  }

  BarTouchData barTouchData(BuildContext context) => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => context.bgPrimaryHoverPressed,
          tooltipPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          tooltipMargin: 8,
          fitInsideVertically: true,
          fitInsideHorizontally: true,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            final record = stepChartManager.aggregatedStepRecords[group.x];
            return BarTooltipItem(
              '',
              TextStyle(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
              children: [
                TextSpan(
                    text: '총\n',
                    style: TextStyles.caption1.secondaryColor(context)),
                TextSpan(
                    text: '${record?.avgStepCount}',
                    style: TextStyles.headline3.bold.primaryColor(context)),
                TextSpan(
                    text: ' 걸음\n',
                    style: TextStyles.body2.primaryColor(context)),
                TextSpan(
                    text: record?.formattedDate,
                    style: TextStyles.caption1.secondaryColor(context))
              ],
            );
          },
        ),
      );

  Widget getTitles(
    Color textColor,
    double value,
    TitleMeta meta,
  ) {
    final xLabels = stepChartManager.xLabels;

    final hasValue = xLabels.contains(value.toInt());

    if (!hasValue) {
      return const SizedBox.shrink();
    }

    final record = stepChartManager.aggregatedStepRecords[value.toInt()];

    final style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return Text(record?.startDate.toMD() ?? '', style: style);
  }

  FlTitlesData titlesData(BuildContext context) => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) =>
                getTitles(context.textPrimary, value, meta),
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );
}

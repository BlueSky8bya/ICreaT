import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/constants/box_shadows.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/layout/title_row_widget.dart';
import 'package:icreat_dct/3_view/components/wrapper/init_wrap.dart';
import 'package:icreat_dct/3_view/navbar/measurement/components/daily_sleep_card.dart';
import 'package:icreat_dct/3_view/navbar/measurement/components/daily_step_card.dart';
import 'package:icreat_dct/3_view/navbar/measurement/components/device_card.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/measurement_view_model.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class MeasurementView extends GetView<MeasurementViewModel> {
  const MeasurementView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InitWrap(
      controller: controller,
      builder: () => SafeScaffold(
        backgroundColor: context.bgPrimary,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(
                      controller.currentDate.toKoreanYMD(),
                      style: TextStyles.headline1.semiBold,
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Obx(
                            () => DailyStepCard(
                              stepRecord: controller.todayStepRecord,
                              onTap: () =>
                                  controller.handleTapStepStatistics(context),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => DailySleepCard(
                              dailySleepRecord: controller.todaySleepRecord,
                              onTap: () =>
                                  controller.handleTapSleepStatistics(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _DeviceSection(
                  onTap: (type) => controller.onTapMeasureType(context, type),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceSection extends StatelessWidget {
  final Function(MeasurementType type) onTap;

  const _DeviceSection({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: context.bgPrimary,
        boxShadow: BoxShadows.shadow4,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleRowWidget(title: '무엇을 측정하시겠나요?'),
            Row(
              spacing: 12,
              children: [
                ...[
                  MeasurementType.bloodPressure,
                  MeasurementType.bodyWeight,
                  MeasurementType.temperature,
                ].map(
                  (type) => Expanded(
                    child: DeviceCard(
                      svgIcon: type.svgIcon,
                      label: type.label,
                      onTap: () => onTap(type),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

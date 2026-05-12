import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/rounded_card.dart';
import 'package:icreat_dct/3_view/components/wrapper/bouncing_scroll_view.dart';
import 'package:icreat_dct/3_view/components/wrapper/progress_wrap.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_guide_image.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/components/guide_slider.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/temperature_result_view_model.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class TemperatureResultView extends GetView<TemperatureResultViewModel> {
  const TemperatureResultView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressWrap(
      controller: controller,
      child: SafeScaffold(
        appBar: CommonAppBar.title(
          context,
          title: '체온 기록',
        ),
        child: Column(
          children: [
            _buildContents(),
            BottomSection(
              children: [
                Obx(
                  () => Row(
                    spacing: 16,
                    children: [
                      if (controller.isDisconnected)
                        Expanded(
                          child: SolidButton(
                            text: '다시 연결',
                            onTap: () =>
                                controller.retry(context, controller.type),
                          ).expand.large.outline(context),
                        ),
                      Expanded(
                        child: SolidButton(
                          text: '저장',
                          onTap: () => controller.saveResult(context),
                        ).expand.large.primary(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContents() {
    return Expanded(
      child: BouncingScrollView(
        child: Column(
          spacing: 16,
          children: [
            // _buildBattery(),
            GuideSlider(
              imagePathList: MeasurementGuideImage.measureTemperatureGuides,
            ),
            _buildTemperatureValue(),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureValue() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RoundedCard(
        child: Row(
          children: [
            Text('체온', style: TextStyles.body1),
            Spacer(),
            Obx(() => Text(
                  '${controller.temperature.value.recordValue} ${controller.temperature.value.unitString}',
                  style: TextStyles.headline1,
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/text/loading_text.dart';
import 'package:icreat_dct/3_view/components/wrapper/init_wrap.dart';
import 'package:icreat_dct/3_view/navbar/measurement/components/connect_progress_widget.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/components/guide_slider.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/weight_connecting_view_model.dart';

class WeightConnectingView extends GetView<WeightConnectingViewModel> {
  const WeightConnectingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InitWrap(
      controller: controller,
      builder: () => ConnectProgressWidget(
        type: MeasurementType.bodyWeight,
        controller: controller,
        child: SafeScaffold(
          appBar: CommonAppBar.title(
            context,
            title: '체중 측정',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Obx(
                  () => GuideSlider(
                    sliderController: controller.sliderController,
                    imagePathList: controller.guideType.value.imageSources,
                    autoPlay: controller.isReadingCompleted.value,
                    onPageChanged: controller.onSliderPageChanged,
                  ),
                ),
              ),
              BottomSection(
                children: [
                  Obx(
                    () {
                      if (controller.isConnecting.value) {
                        return const LoadingText(text: '측정 결과를 기다리고 있어요');
                      }
                      return SolidButton(
                        onTap: () => controller.startConnect(),
                        text: controller.isReadingCompleted.value
                            ? '연결을 시작합니다.'
                            : '가이드를 전부 읽어주세요.',
                      ).expand.large;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

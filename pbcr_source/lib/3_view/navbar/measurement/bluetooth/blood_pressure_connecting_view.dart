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
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/blood_pressure_connecting_view_model.dart';

class BloodPressureConnectingView
    extends GetView<BloodPressureConnectingViewModel> {
  const BloodPressureConnectingView({super.key});

  @override
  Widget build(BuildContext context) {
    return InitWrap(
      controller: controller,
      builder: () => ConnectProgressWidget(
        controller: controller,
        type: MeasurementType.bloodPressure,
        child: SafeScaffold(
          appBar: CommonAppBar.title(
            context,
            title: '혈압 측정',
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
                        return LoadingText(text: '연결 중입니다...');
                      }
                      return SolidButton(
                        onTap: () => controller.startConnect(),
                        text: '연결 시작!',
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

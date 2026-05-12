import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/text/loading_text.dart';
import 'package:icreat_dct/3_view/components/wrapper/init_wrap.dart';
import 'package:icreat_dct/3_view/navbar/measurement/components/connect_progress_widget.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_guide_image.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/components/guide_slider.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/temperature_connecting_view_model.dart';

class TemperatureConnectingView
    extends GetView<TemperatureConnectingViewModel> {
  const TemperatureConnectingView({super.key});

  @override
  Widget build(BuildContext context) {
    return InitWrap(
      controller: controller,
      builder: () => ConnectProgressWidget(
        type: MeasurementType.temperature,
        controller: controller,
        child: SafeScaffold(
          appBar: CommonAppBar.title(
            context,
            title: '주변 체온계 연결',
          ),
          child: LayoutBuilder(builder: (context, box) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: GuideSlider(
                    imagePathList: MeasurementGuideImage.temperatureGuides,
                  ),
                ),
                BottomSection(
                  children: [
                    LoadingText(text: '주변 체온계를 찾고 있어요'),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

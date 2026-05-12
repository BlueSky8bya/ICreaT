import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/3_view/components/loading/loading_view.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/6_util/text_widget_util.dart';
import 'package:icreat_dct/theme/color_hue.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class ConnectProgressWidget extends StatelessWidget {
  const ConnectProgressWidget({
    super.key,
    required this.controller,
    required this.child,
    required this.type,
  });

  final Widget child;
  final BaseViewModel controller;
  final MeasurementType type;

  @override
  Widget build(BuildContext context) {
    final noticeText = '${type.deviceName}와 통신 중이에요\n잠시만 기다려 주세요';

    final width = TextWidgetUtil.getTextWidth(
      text: noticeText,
      style: TextStyles.body1,
    );

    return Obx(
      () => PopScope(
        onPopInvokedWithResult: (popInvoked, result) {
          if (popInvoked) return;
          if (controller.isOnProgress.value) return;
          context.pop(result);
        },
        child: Stack(
          children: [
            child,
            if (controller.isOnProgress.value)
              Container(
                width: Get.width,
                height: Get.height,
                decoration: const BoxDecoration(
                  color: Color(0x4F000000),
                ),
                child: Center(
                  child: Material(
                    color: ColorHue.white,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: width + 50,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            noticeText,
                            textAlign: TextAlign.center,
                            style: TextStyles.body1,
                          ),
                          const SizedBox(height: 12),
                          const LoadingView(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

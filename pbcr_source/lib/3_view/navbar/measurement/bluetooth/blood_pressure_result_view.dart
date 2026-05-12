import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/text_field/outline_text_field.dart';
import 'package:icreat_dct/3_view/components/wrapper/bouncing_scroll_view.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/blood_pressure_result_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class BloodPressureResultView extends GetView<BloodPressureResultViewModel> {
  const BloodPressureResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final labelTextStyle = TextStyles.caption1.tertiaryColor(context);
    final suffixTextStyle = TextStyles.body2;

    return SafeScaffold(
      backgroundColor: context.bgPrimary,
      appBar: CommonAppBar.title(
        context,
        title: '혈압 결과',
      ),
      child: Column(
        children: [
          Expanded(
            child: BouncingScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  OutlineTextField(
                    label: Text('수축기', style: labelTextStyle),
                    controller: TextEditingController(
                      text: '${controller.bloodPressureModel.systole}',
                    ),
                    onChanged: (value) {},
                    suffix: Text('mmHg', style: suffixTextStyle),
                    readOnly: true,
                  ),
                  OutlineTextField(
                    label: Text('이완기', style: labelTextStyle),
                    controller: TextEditingController(
                      text: '${controller.bloodPressureModel.diastole}',
                    ),
                    onChanged: (value) {},
                    suffix: Text('mmHg', style: suffixTextStyle),
                    readOnly: true,
                  ),
                  OutlineTextField(
                    label: Text('맥박', style: labelTextStyle),
                    controller: TextEditingController(
                      text: '${controller.bloodPressureModel.pulse}',
                    ),
                    onChanged: (value) {},
                    suffix: Text('bpm', style: suffixTextStyle),
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          BottomSection(
            children: [
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: SolidButton(
                      text: '다시 측정',
                      onTap: () => controller.retry(context, controller.type),
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
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/text_field/outline_text_field.dart';
import 'package:icreat_dct/3_view/components/text_field/text_field_input_formatter.dart';
import 'package:icreat_dct/3_view/navbar/measurement/manual/blood_pressure_manual_input_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class BloodPressureManualInputView
    extends GetView<BloodPressureManualInputViewModel> {
  const BloodPressureManualInputView({super.key});

  @override
  Widget build(BuildContext context) {
    final labelTextStyle = TextStyles.caption1.tertiaryColor(context);
    final suffixTextStyle = TextStyles.body2;

    return SafeScaffold(
      appBar: CommonAppBar(
        title: Text(
          '혈압 직접 입력',
          style: TextStyles.body1.semiBold.primaryColor(context),
        ),
      ),
      backgroundColor: context.bgPrimary,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '혈압을 직접 입력하세요.',
                        style: TextStyles.body2.medium.primaryColor(context),
                      ),
                    ),
                    Column(
                      spacing: 16,
                      children: [
                        for (final entry in controller.tcMap.entries)
                          OutlineTextField(
                            controller: entry.value,
                            focusNode: controller.focusNodeMap[entry.key],
                            label: Text(
                              entry.key.name,
                              style: labelTextStyle,
                            ),
                            suffix: Text(
                              entry.key.suffix,
                              style: suffixTextStyle,
                            ),
                            onChanged: (value) {
                              controller.handleValueChange(entry.key, value);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              TextFieldInputFormatter.numberOnlyInputFormatter,
                            ],
                            maxLines: 1,
                            maxLength: 3,
                            textInputAction: TextInputAction.next,
                          ),
                      ],
                    ),
                    Obx(
                      () => controller.errMsg.isNotEmpty
                          ? Text(
                              controller.errMsg,
                              style: TextStyles.body2.dangerColor(context),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomSection(children: [
            SolidButton(
              text: '저장',
              isExpanded: true,
              onTap: () => controller.saveBloodPressure(context),
            ).large,
          ]),
        ],
      ),
    );
  }
}

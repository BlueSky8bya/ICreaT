import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/text_field/outline_text_field.dart';
import 'package:icreat_dct/3_view/components/text_field/text_field_input_formatter.dart';
import 'package:icreat_dct/3_view/navbar/measurement/manual/weight_manual_input_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class WeightManualInputView extends GetView<WeightManualInputViewModel> {
  const WeightManualInputView({super.key});

  @override
  Widget build(BuildContext context) {
    final labelTextStyle = TextStyles.body2.medium;
    final suffixTextStyle = TextStyles.body2;

    return SafeScaffold(
      appBar: CommonAppBar(
        title: Text(
          '몸무게 직접 입력',
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
                        '몸무게를 직접 입력하세요.',
                        style: TextStyles.body2.medium.primaryColor(context),
                      ),
                    ),
                    OutlineTextField(
                      label: Text('몸무게', style: labelTextStyle),
                      suffix: Text('kg', style: suffixTextStyle),
                      controller: controller.tc,
                      hintText: '숫자만 입력해주세요.',
                      onChanged: (value) {},
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      maxLines: 1,
                      maxLength: 5,
                      inputFormatters: [
                        TextFieldInputFormatter.decimalOnlyInputFormatter,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomSection(
            children: [
              SolidButton(
                text: '저장',
                isExpanded: true,
                onTap: () => controller.saveWeight(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/bottom_section.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/text_field/outline_text_field.dart';
import 'package:icreat_dct/3_view/components/wrapper/bouncing_scroll_view.dart';
import 'package:icreat_dct/3_view/components/wrapper/init_wrap.dart';
import 'package:icreat_dct/3_view/components/wrapper/progress_wrap.dart';
import 'package:icreat_dct/3_view/navbar/measurement/bluetooth/weight_result_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class WeightResultView extends GetView<WeightResultViewModel> {
  const WeightResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final labelTextStyle = TextStyles.caption1.tertiaryColor(context);
    final suffixTextStyle = TextStyles.body2;

    return InitWrap(
      controller: controller,
      builder: () => ProgressWrap(
        controller: controller,
        child: SafeScaffold(
          appBar: CommonAppBar.title(
            context,
            title: '체중 기록',
          ),
          backgroundColor: context.bgPrimary,
          child: Column(
            children: [
              Expanded(
                child: BouncingScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      OutlineTextField(
                        label: Text('체중', style: labelTextStyle),
                        controller: TextEditingController(
                          text: controller.weight,
                        ),
                        onChanged: (value) {},
                        suffix: Text('kg', style: suffixTextStyle),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

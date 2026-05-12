import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/layout/title_row_widget.dart';
import 'package:icreat_dct/3_view/navbar/measurement/select/measurement_select_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class MeasurementSelectView extends GetView<MeasurementSelectViewModel> {
  const MeasurementSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: CommonAppBar.title(context, title: controller.appbarTitle),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TitleRowWidget(title: '측정 방법을 선택해 주세요.'),
            ),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _SelectButton(
                      icon: SvgIcons.pencil,
                      text: '직접 입력',
                      onTap: () => controller.handleNavigateToManual(context),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _SelectButton(
                      icon: SvgIcons.bluetooth,
                      text: '블루투스',
                      onTap: () =>
                          controller.handleNavigateToBluetooth(context),
                    ),
                  ),
                ),
              ],
            ),
            // BottomSection(
            //   children: [
            //     SolidButton(
            //       text: '돌아가기',
            //       onTap: () => controller.handlePop(context),
            //     ).large.expand,
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  final SvgIcons icon;
  final String text;
  final VoidCallback onTap;

  const _SelectButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.borderPrimary,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon.svgPath,
                width: 54,
                height: 54,
              ),
              Text(
                text,
                style: TextStyles.body2.semiBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/labeled_divider.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/text_field/outline_text_field.dart';
import 'package:icreat_dct/3_view/login/login_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class LoginView extends GetView<LoginViewModel> {
  const LoginView({super.key});

  ButtonStyle defaultButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeScaffold(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              _JoinHeader(
                title: '환영합니다.',
                subTitle: '로그인 후 서비스를 이용해주세요.',
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  OutlineTextField(
                    controller: controller.tcProjectId,
                    label: Text('과제번호',
                        style: TextStyles.caption1.tertiaryColor(context)),
                    hintText: '과제번호 입력',
                    maxLines: 1,
                    maxLength: 30,
                  ),
                  OutlineTextField(
                    controller: controller.tcSubjectId,
                    label: Text('대상자번호',
                        style: TextStyles.caption1.tertiaryColor(context)),
                    hintText: '대상자번호 입력',
                    maxLines: 1,
                    maxLength: 30,
                  ),
                  OutlineTextField(
                    controller: controller.tcPassword,
                    label: Text('비밀번호',
                        style: TextStyles.caption1.tertiaryColor(context)),
                    hintText: '비밀번호 입력',
                    obscureText: true,
                    maxLines: 1,
                    maxLength: 30,
                  ),
                ],
              ),
              // 로그인 버튼
              SolidButton(
                text: '로그인',
                borderRadius: isKeyboardVisible ? 0 : 8,
                onTap: () => controller.handleLogin(context),
              ).expand.extraLarge,
              // 디바이더
              LabeledDivider(
                label: '또는',
                labelStyle: TextStyles.caption1.tertiaryColor(context),
                dividerColor: context.borderPrimary,
              ),
              // QR 코드 스캔 버튼
              SolidButton(
                text: 'QR 코드 스캔',
                borderRadius: isKeyboardVisible ? 0 : 8,
                onTap: () => controller.handleQrCode(context),
              ).expand.extraLarge.tertiary(context),
            ],
          ),
        ),
      ),
    );
  }
}

class _JoinHeader extends StatelessWidget {
  final String title;
  final String subTitle;

  const _JoinHeader({
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            title,
            style: TextStyles.headline1.semiBold,
          ),
          Text(
            subTitle,
            style: TextStyles.body2.tertiaryColor(context),
          ),
        ],
      ),
    );
  }
}

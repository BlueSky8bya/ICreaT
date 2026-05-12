import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/wrapper/bouncing_scroll_view.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/myinfo_view_model.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/4_router/route_type.dart';
import 'package:icreat_dct/6_util/text_widget_util.dart';
import 'package:icreat_dct/6_util/toast_util.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

import 'consent/file_downloader.dart';

class MyInfoView extends GetView<MyInfoViewModel> {
  const MyInfoView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      backgroundColor: context.bgPrimaryHoverPressed,
      child: BouncingScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text('과제 정보', style: TextStyles.headline2.semiBold),
              Obx(() => InfoCardWidget(
                  info: {
                    '과제 번호': controller.projectNo,
                    '과제 이름': controller.projectName,
                    '과제 시작 일자': controller.projectStartDate.toDashYMD(),
                    '과제 종료 일자': controller.projectEndDate.toDashYMD(),
                    '대상자 번호': controller.subjectNo,
                    '대상자 이름': controller.subjectName,
                  },
                  baseText: '과제 종료 일자',
              )),
              Text('동의서 열람', style: TextStyles.headline2.semiBold),
              Obx(() => Row(
                children: [
                  if (controller.icfDocumentFileUrl.isNotEmpty)
                    ...[
                      Expanded(
                        child: SolidButton(
                          leadingIcon: Icon(Icons.search),
                          iconSpacing: 8,
                          onTap: () => CommonNavigator.toConsentViewSimple(context),
                          text: '보기',
                        ).tertiary(context).expand.large,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FileDownloadButton(
                          fileUrl: controller.icfDocumentFileUrl,
                          fileName: controller.icfDocumentFileName,
                          sessionId: controller.sessionId,
                          onPermission: (err) => ToastUtil.showToast(err),
                          onError: () => ToastUtil.showToast("동의서 다운로드에 실패하였습니다."),
                          onFinish: (path) => ToastUtil.showToast("$path에 다운로드 되었습니다."),
                        ),
                      ),
                    ],
                  if (controller.icfDocumentFileUrl.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text('열람 가능한 동의서 문서가 없습니다.')
                    ),
                ],
              )),
              Text('도움이 필요하신가요?', style: TextStyles.headline2.semiBold),
              SolidButton(
                onTap: () => CommonNavigator.toAppManualSimple(context),
                text: '앱 사용 방법',
              ).tertiary(context).expand.large,
              Text('도구',style: TextStyles.headline2.semiBold),
              SolidButton(
                onTap: () => context.pushNamed(RouteType.localNotificationList.name),
                text: '알림 설정',
              ).tertiary(context).expand.large,
              Align(
                alignment: Alignment.bottomRight,
                child: Obx(() => Text(
                    'v${controller.appVersion}',
                    style: TextStyles.caption1.medium.tertiaryColor(context),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCardWidget extends StatelessWidget {
  final Map<String, String> info;
  final String baseText;

  const InfoCardWidget({
    super.key,
    required this.info,
    required this.baseText,
  });

  @override
  Widget build(BuildContext context) {
    final maxTextWidth = TextWidgetUtil.getMaxTextWidth(
      texts: info.keys.toList(),
      style: TextStyles.body2.medium,
    );

    const textPadding = 16.0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      color: context.bgPrimary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          children: [
            ...info.entries.map(
              (entry) => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: maxTextWidth + textPadding,
                    child: Text(
                      entry.key,
                      style: TextStyles.body2.medium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyles.body2.tertiaryColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

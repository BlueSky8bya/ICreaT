import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/wrapper/init_wrap.dart';
import 'package:icreat_dct/3_view/navbar/myinfo/app_manual/app_manual_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class AppManualView extends GetView<AppManualViewModel> {
  const AppManualView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InitWrap(
      controller: controller,
      builder: () {
        return SafeScaffold(
          backgroundColor: context.bgPrimary,
          appBar: AppBar(
            title: const Text('앱 사용법'),
            backgroundColor: context.bgPrimary,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
          child: Stack(
            children: [
              PDFViewer(
                document: controller.manual,
                showPicker: false,
              )
            ],
          ),
        );
      },
    );
  }
}

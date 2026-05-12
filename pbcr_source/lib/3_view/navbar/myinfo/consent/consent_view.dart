import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/wrapper/init_wrap.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

import 'consent_view_model.dart';

class ConsentView extends GetView<ConsentViewModel> {
  const ConsentView({
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
            title: const Text('연구 동의서'),
            backgroundColor: context.bgPrimary,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
          child: Obx(() => Center(
            child: controller.isLoading ?
              Center(child: CircularProgressIndicator()) :
              (controller.document == null ?
                Text("연구 동의서를 찾을 수 없습니다.") :
                PDFViewer(
                  document: controller.document!,
                  showPicker: false,
                )
              )
          )),
        );
      },
    );
  }
}

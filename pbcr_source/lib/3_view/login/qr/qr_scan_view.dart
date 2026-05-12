import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/appbar/common_app_bar.dart';
import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/wrapper/progress_wrap.dart';
import 'package:icreat_dct/3_view/login/qr/qr_scan_view_model.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScanView extends GetView<QrScanViewModel> {
  const QrScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var curOutSize = min(deviceSize.width * 0.8, deviceSize.height * 0.8);
    return ProgressWrap(
      controller: controller,
      child: SafeScaffold(
        backgroundColor: context.bgPrimary,
        appBar: CommonAppBar(
          title: Text('QR 스캔', style: TextStyles.body2.primaryColor(context)),
          backgroundColor: context.bgPrimary,
        ),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: QRView(
            key: controller.qrKey,
            onQRViewCreated: controller.onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: context.bgDanger,
              borderRadius: 12,
              borderLength: 32,
              borderWidth: 12,
              cutOutSize: curOutSize,
            ),
            onPermissionSet: (ctrl, p) =>
                controller.onPermissionSet(context, ctrl, p),
          ),
        ),
      ),
    );
  }
}

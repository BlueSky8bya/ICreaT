import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/0_data/dto/auth/qr_scan_result_res.dart';
import 'package:icreat_dct/1_service/permission_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScanViewModel extends BaseViewModel {
  final BuildContext _context;
  final PermissionService _permissionService;

  QrScanViewModel(this._context, this._permissionService);

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isParsing = false;
  bool isParsingCompleted = false;

  @override
  void onInit() {
    super.onInit();
    _checkCameraPermission();
  }

  void _checkCameraPermission() async {
    final isGranted = await _permissionService.checkCameraPermission();
    if (!isGranted) {
      if (!_context.mounted) return;
      await _permissionService.requestCameraPermission(_context);
    }
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    if (DeviceInfo.isAndroid) controller.resumeCamera();
    controller.scannedDataStream.listen(_onScannedDataReceived);
  }

  void _onScannedDataReceived(Barcode barcode) {
    Logger.debug('scanData.code = ${barcode.code}');

    if (barcode.code != null) {
      _parsingQrData(barcode.code!);
    }
  }

  void _parsingQrData(String code) async {
    if (isParsing) return;
    isParsing = true;

    showProgress();

    if (!_isJson(code)) {
      Logger.error('QR 데이터 파싱 실패: $code');
      _completeQrParsing();
    } else {
      final json = jsonDecode(code);
      final qrScanResult = QrScanResultRes.fromJson(json);
      _completeQrParsing(qrScanResult);
    }
  }

  bool _isJson(String code) {
    try {
      jsonDecode(code);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 한번 스캔할 때마다 두번 실행되서 isParsingCompleted로 체크
  void _completeQrParsing([QrScanResultRes? qrScanResult]) {
    dismissProgress();
    isParsing = false;
    if (qrScanResult != null) {
      _context.pop(qrScanResult);
    }
  }

  void onPermissionSet(
    BuildContext context,
    QRViewController ctrl,
    bool p,
  ) async {
    // if (!p) {
    //   Get.back();
    //   _permissionHelper.showRequestCameraPermissionSnackbar();
    // }
  }
}

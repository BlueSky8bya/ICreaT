import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:file_saver/file_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../6_util/logger.dart';
import '../../../components/button/solid_button.dart';

// --- 파일 다운로드 서비스 클래스 ---
class FileDownloader {
  final Dio _dio = Dio();

  // 파일 다운로드 함수
  Future<void> downloadFile(
      String fileUrl,
      String fileName,
      String sessionId,
      Function(int received, int total) onProgress,
      Function(String path) onDone,
      Function(DioException e) onError,
  ) async {
    try {

      if (Platform.isIOS) {

        // Dio를 사용하여 파일 데이터를 바이트로 가져옵니다.

        final response = await _dio.get<List<int>>(
          fileUrl,
          options: Options(
            responseType: ResponseType.bytes,
            headers: {
              'Dct-Session-Id': sessionId
            }
          ),
          onReceiveProgress: onProgress,
        );

        final bytes = Uint8List.fromList(response.data!);

        // file_saver를 사용하여 파일 저장
        String? savePath = await FileSaver.instance.saveFile(
          name: fileName,
          bytes: bytes,
          ext: "pdf",
          mimeType: MimeType.pdf,
        );

        onDone(savePath);

      } else {
        await FileSaver.instance.saveAs(
          name: fileName,
          link: LinkDetails(
            link: fileUrl,
            headers: {
             'Dct-Session-Id': sessionId
            }
          ),
          ext: "pdf",
          mimeType: MimeType.pdf,
        );

        onDone(fileName);
      }

    } on DioException catch (e) {
      onError(e);
    } catch (e) {
      onError(DioException(requestOptions: RequestOptions(path: fileUrl), error: e.toString()));
    }
  }
}

// --- Flutter UI 위젯 ---
class FileDownloadButton extends StatefulWidget {

  final VoidCallback onError;
  final void Function(String) onPermission;
  final void Function(String) onFinish;
  final String fileUrl;
  final String fileName;
  final String sessionId;

  const FileDownloadButton({
    super.key,
    required this.onError,
    required this.onPermission,
    required this.onFinish,
    required this.fileUrl,
    required this.fileName,
    required this.sessionId
  });

  @override
  State<FileDownloadButton> createState() => _FileDownloadButtonState();
}

class _FileDownloadButtonState extends State<FileDownloadButton> {
  final FileDownloader _downloader = FileDownloader();
  final RxString _statusMessage = '다운로드'.obs;

  String get statusMessage =>  _statusMessage.value;

  Future<bool> _handlePermission() async {
    if (Platform.isIOS) {
      return true;
    }

    // API 레벨 확인
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13 이상에서는 저장소 권한이 필요 없습니다.
      return true;
    } else {
      PermissionStatus status = await Permission.storage.request();

      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        widget.onPermission.call("다운로드 불가: 권한이 영구 거부되었습니다. 설정에서 수동으로 허용해주세요.");
        return false;
      } else {
        widget.onPermission.call("저장소 권한이 거부되었습니다. 다시 시도해주세요.");
        return false;
      }
    }
  }

  void resetStatus() {
    Timer(const Duration(seconds: 1),() {
      _statusMessage.value = '다운로드';
    });
  }

  void _startDownload() async {

    setState(() {
      _statusMessage.value = '권한 확인 중...';
    });

    bool isPermissionGranted = await _handlePermission();
    if (!isPermissionGranted) {
      resetStatus();
      return;
    }

    setState(() {
      _statusMessage.value = '다운로드 시작...';
    });

    _downloader.downloadFile(
      widget.fileUrl,
      widget.fileName,
      widget.sessionId,
      (received, total) {
        // 다운로드 진행 상황 업데이트
        if (total != -1) {
          setState(() {
            _statusMessage.value = '${(received / 1024 / 1024).toStringAsFixed(2)}MB / ${(total / 1024 / 1024).toStringAsFixed(2)}MB';
          });
        }
      },
      (savePath) {
        // 다운로드 완료
        setState(() {
          _statusMessage.value = '다운로드 완료';
          widget.onFinish.call(savePath);
          resetStatus();
        });
      },
      (error) {
        // 다운로드 오류

        Logger.debug("$error");

        setState(() {
          _statusMessage.value = '다운로드 실패';
          widget.onError.call();
          resetStatus();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SolidButton(
      leadingIcon: const Icon(Icons.download),
      iconSpacing: 8,
      onTap: () => _startDownload(),
      text: statusMessage,
    ).tertiary(context).expand.large);
  }
}

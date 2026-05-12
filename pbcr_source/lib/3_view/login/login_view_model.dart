import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:icreat_dct/0_data/dto/auth/login_req.dart';
import 'package:icreat_dct/1_service/auth_service.dart';
import 'package:icreat_dct/1_service/project_service.dart';
import 'package:icreat_dct/1_service/event_bus_service.dart';
import 'package:icreat_dct/1_service/secure_storage_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/6_util/toast_util.dart';

enum LoginFormType {
  projectId,
  subjectId,
  password,
}

class LoginViewModel extends BaseViewModel {
  final AuthService _authService;
  final ProjectService _projectService;

  LoginViewModel(this._authService, this._projectService) {
    _loadSavedLoginInfo();
  }

  final Map<LoginFormType, TextEditingController> _tcMap = {
    LoginFormType.projectId: TextEditingController(),
    LoginFormType.subjectId: TextEditingController(),
    LoginFormType.password: TextEditingController(),
  };

  TextEditingController get tcProjectId => _tcMap[LoginFormType.projectId]!;
  TextEditingController get tcSubjectId => _tcMap[LoginFormType.subjectId]!;
  TextEditingController get tcPassword => _tcMap[LoginFormType.password]!;

  // SharedPreferences 키 정의
  static const String _keyProjectId = 'login_project_id';
  static const String _keySubjectId = 'login_subject_id';

  // 저장된 로그인 정보 불러오기
  Future<void> _loadSavedLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    tcProjectId.text = prefs.getString(_keyProjectId) ?? '';
    tcSubjectId.text = prefs.getString(_keySubjectId) ?? '';
  }

  // 로그인 정보 저장하기
  Future<void> _saveLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProjectId, tcProjectId.text);
    await prefs.setString(_keySubjectId, tcSubjectId.text);
  }

  @override
  void dispose() {
    for (var controller in _tcMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void handleQrCode(BuildContext context) {
    CommonNavigator.toQrScan(context).then((result) {
      if (!result.success) {
        return;
      }

      final qrScanResult = result.data;
      if (qrScanResult == null) {
        return;
      }

      tcProjectId.text = qrScanResult.studyNo; // 과제 번호
      tcSubjectId.text = qrScanResult.subjectId; // 대상자 번호

      _saveLoginInfo(); // QR 코드 스캔 후 저장
    });
  }

  void handleLogin(BuildContext context) async {
    final projectId = tcProjectId.text;
    final subjectId = tcSubjectId.text;
    final password = tcPassword.text;

    if (projectId.isEmpty) {
      ToastUtil.showToast('프로젝트 ID를 입력해주세요.');
      return;
    }

    if (subjectId.isEmpty) {
      ToastUtil.showToast('대상자 ID를 입력해주세요.');
      return;
    }

    if (password.isEmpty) {
      ToastUtil.showToast('비밀번호를 입력해주세요.');
      return;
    }

    // 로그인 정보 저장, 로그인 시도 전

    _saveLoginInfo();

    // 로그인

    final loginRes = await _authService.login(LoginReq(
      projectId: projectId,
      subjectId: subjectId,
      password: password,
    ));

    var subjectInfo = loginRes.getOrNull();
    if (subjectInfo == null || !subjectInfo.isSuccess) {
      ToastUtil.showToast('로그인에 실패하였습니다.');
      return;
    }

    await _projectService.updateSubjectInfo(
      projectId: projectId,
      subjectId: subjectId,
      pid: subjectInfo.pid,
      subjectName: subjectInfo.patName
    );

    final projectInfoRes = await _projectService.getProjectInfo(subjectInfo.dctSessionId);
    var projectInfo = projectInfoRes.getOrNull();
    if (projectInfo == null) {
      ToastUtil.showToast('과제 정보가 없습니다. 연구진에게 문의해주세요.');
      return;
    }

    await _projectService.updateProjectInfo(
      organCode: projectInfo.organCode,
      icfDocument: projectInfo.icfDocument,
    );

    SecureStorageService().saveSessionToken(subjectInfo.dctSessionId);
    EventBusService().fire(EventSubjectLoggedIn()); // event fire!

    if (context.mounted) {
      CommonNavigator.toMain(context);
    } else {
      ToastUtil.showToast('context error');
    }
  }
}

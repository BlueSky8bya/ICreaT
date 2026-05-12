import 'dart:async';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:icreat_dct/1_service/project_service.dart';
import 'package:icreat_dct/1_service/secure_storage_service.dart';
import 'package:icreat_dct/1_service/event_bus_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/6_util/toast_util.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';

class MyInfoViewModel extends BaseViewModel {
  final ProjectService _projectService;

  final List<StreamSubscription> _eventSubscribeList = [];


  MyInfoViewModel(
    this._projectService,
  );

  final Rx<String> _projectNo = '(과제번호)'.obs;               // 프로젝트 번호(과제 번호)
  final Rx<String> _projectName = '(과제이름)'.obs;             // 프로젝트 이름
  final Rx<String> _subjectNo = '(대상자번호)'.obs;             // 대상자 번호
  final Rx<String> _subjectName = '(대상자이름)'.obs;           // 대상자 이름
  final Rx<DateTime> _projectStartDate = DateTime.now().obs;  // 프로젝트 기간
  final Rx<DateTime> _projectEndDate = DateTime.now().obs;
  final Rx<String> _appVersion = '앱버전'.obs;                 // 앱 버전
  final Rx<String> _icfDocument = ''.obs;                     // 동의서  URL
  final Rx<String> _organCode = '(기관번호)'.obs;               // 기관번호
  final Rx<String> _sessionId = "".obs;

  String get projectNo => _projectNo.value;
  String get projectName => _projectName.value;
  String get subjectNo => _subjectNo.value;
  String get subjectName => _subjectName.value;
  DateTime get projectStartDate => _projectStartDate.value;
  DateTime get projectEndDate => _projectEndDate.value;
  String get appVersion => _appVersion.value;
  String get icfDocumentFileUrl => _icfDocument.value;
  String get icfDocumentFileName => "[$projectNo]_연구동의서_($subjectName)";
  String get organCode => _organCode.value;
  String get sessionId => _sessionId.value;

  @override
  void onInit() async {
    super.onInit();

    // event bus subscribe

    _eventSubscribeList.add(EventBusService().subscribe<EventSessionExpired>((event) {
      Logger.debug("event handle: $EventSessionExpired on MyInfoViewModel");
    }));

    await _loadProjectInfo();
    await _loadAppVersion();

    _subjectNo.value = _projectService.subjectId;
    _subjectName.value = _projectService.subjectName;

    _sessionId.value = (await SecureStorageService().getSessionToken()) ?? "";

    completeInit();
  }

  @override
  void onClose() {
    EventBusService().unsubscribeAll(_eventSubscribeList);
    super.onClose();
  }

  Future<void> _loadProjectInfo() async {
    String? sessionId = await SecureStorageService().getSessionToken();
    if (sessionId == null) {
      ToastUtil.showToast('세션 정보가 없습니다. 다시 로그인해주세요.');
      return;
    }
    final result = await _projectService.getProjectInfo(sessionId);
    final projectInfo = result.getOrNull();
    if (projectInfo != null) {

      await _projectService.updateProjectInfo(icfDocument: projectInfo.icfDocument);

      _projectNo.value = projectInfo.studyNo;
      _projectName.value = projectInfo.studyName.isEmpty ? projectInfo.studyFullName : projectInfo.studyName;
      _projectStartDate.value = projectInfo.startDate.toDateTimeFromYMD();
      _projectEndDate.value = projectInfo.endDate.toDateTimeFromYMD();
      _icfDocument.value = _projectService.icfDocument;
    } else {
      ToastUtil.showToast('프로젝트 정보 로드에 실패했습니다.');
    }
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion.value = packageInfo.version;
    } catch (e) {
      Logger.error('Failed to load app version: $e');
      _appVersion.value = '알 수 없음';
    }
  }
}

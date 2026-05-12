import 'package:icreat_dct/0_data/model/project_info.dart';
import 'package:icreat_dct/0_data/model/type/request_result.dart';
import 'package:icreat_dct/0_data/dto/project/project_info_res.dart';
import 'package:icreat_dct/2_repository/icreat_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';

class ProjectService {
  final IcreatRepository _icreatRepo;
  final PrefRepository _prefRepo;
  ProjectInfoModel? _projectInfo;

  ProjectService(
    this._icreatRepo,
    this._prefRepo,
  );

  bool get hasProjectInfo => _projectInfo != null;
  ProjectInfoModel? get projectInfo => _projectInfo;
  String get projectId => _prefRepo.projectId ?? '';      // 로그인 후 저장된 프로젝트 정보
  String get subjectId => _prefRepo.subjectId ?? '';      // 로그인 후 저장된 참가자 정보 (번호)
  String get subjectName => _prefRepo.patName ?? '';      // 로그인 후 저장된 참가자 정보 (이름 이니셜)
  String get organCode => _prefRepo.organCode ?? '';      // 기관 코드
  String get icfDocument => _prefRepo.icfDocument ?? '';  // 동의서

  Future<RequestResult<ProjectInfoModel>> getProjectInfo(String sessionId) =>
      handleRequest(() async {
        final result = await _icreatRepo.getProjectInfo(sessionId);
        final projectInfo = result.toModel();
        _projectInfo = projectInfo;
        return projectInfo;
      });

  /// 로그인 정보(프로젝트 정보, 대상자 정보) 저장
  Future<void> updateSubjectInfo({
    String? projectId,
    String? subjectId,
    String? pid,
    String? subjectName,
  }) async {
    if (!projectId.isNullOrEmpty) {
      await _prefRepo.setProjectId(projectId);
    }
    if (!subjectId.isNullOrEmpty) {
      await _prefRepo.setSubjectId(subjectId);
    }
    if (!pid.isNullOrEmpty) {
      await _prefRepo.setPid(pid);
    }
    if (!subjectName.isNullOrEmpty) {
      await _prefRepo.setPatName(subjectName);
    }
  }

  // 프로젝트 정보 저장
  Future<void> updateProjectInfo({
    String? projectId,
    String? organCode,
    String? icfDocument,
  }) async {
    if (!projectId.isNullOrEmpty) {
      await _prefRepo.setProjectId(projectId);
    }
    if (!organCode.isNullOrEmpty) {
      await _prefRepo.setOrganCode(organCode);
    }
    if (!icfDocument.isNullOrEmpty) {
      await _prefRepo.setIcfDocument(icfDocument);
    }
  }
}

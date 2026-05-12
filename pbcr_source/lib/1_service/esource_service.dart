import 'package:collection/collection.dart';

import 'package:icreat_dct/0_data/model/esource/esource_submission_status.dart';
import 'package:icreat_dct/0_data/model/type/request_result.dart';
import 'package:icreat_dct/2_repository/esource_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/2_repository/impl/esource_database_helper.dart';

class EsourceService {
  final EsourceRepository _eSrcRepo;
  final PrefRepository _prefRepo;
  final EsourceDatabaseHelper _dbHelper;

  EsourceService(this._eSrcRepo, this._prefRepo) : _dbHelper = EsourceDatabaseHelper();

  /// formSeq로 데이터를 eSource에 업로드하고 로컬 DB에 매핑 저장
  Future<int> submit(
    Map<String, dynamic> request,
    String serviceUUID,
    int formSeq,
    int studyEventSeq,
    String visitOccurrenceId,
    String formName,
  ) async {
    final reqResult = await handleRequest(() async {
      return await _eSrcRepo.postCrfData(request);
    });

    final res = reqResult.getOrNull();
    if (res != null && res.isSuccess) {
      return await _dbHelper.insertMapping(EsourceSubmissionStatus(
        formSeq: formSeq,
        studyEventSeq: studyEventSeq,
        uuid: serviceUUID,
        visitOccurrenceId: visitOccurrenceId,
        formName: formName,
        createdAt: DateTime.now(),
        status: EsourceStatus.pending.value, // must be pending
      )); // status Id
    }

    return -1;
  }

  Future<EsourceSubmissionStatus?> getSubmissionStatusFromLocal(
    int studyEventSeq,
    int formSeq,
  ) {
    return _dbHelper.getMappingByFormSeq(studyEventSeq, formSeq);
  }

  /// visitOccurrenceId와 formName으로 eSource 상태 확인
  Future<(EsourceStatus, bool, bool)> getUpdatedSubmissionStatus(
    int studyEventSeq,
    int formSeq,
    String visitOccurrenceId,
    String formName,
  ) async {

    String studyOid = _prefRepo.projectId ?? '';
    String personId = _prefRepo.subjectId ?? '';

    // 1) get UUID - without uuid we cannot get esource status
    final status = await _dbHelper.getMappingByFormSeq(studyEventSeq, formSeq);
    if (status == null) {
      return (EsourceStatus.nil, false, false);
    }

    // 2) get status from eSource
    final resp = await _eSrcRepo.getTransProcStat(status.uuid, studyOid);
    if (resp == null) {
      await _dbHelper.updateStatusById(
        status.id,
        EsourceStatus.dataError.value,
        errorMessage: "response error on transaction process status",
      );
      return (EsourceStatus.dataError, true, false);
    }

    // 3) check status
    final found = resp.data.firstWhereOrNull((el) =>
      el.personId == personId &&
      el.visitOccurrenceId == visitOccurrenceId &&
      el.formName == formName);


    if (found == null) {
      await _dbHelper.updateStatusById(
        status.id,
        EsourceStatus.dataError.value,
        errorMessage: "cannot find visit",
      );
      return (EsourceStatus.dataError, true, false);
    }

    final newStatus = EsourceStatus.fromProcStatCd(found.procStatCd);
    await _dbHelper.updateStatusById(
      status.id,
      newStatus.value,
      errorMessage: null,
    );

    // 업데이트된 매핑 반환
    return (newStatus, true, true);
  }

  /// 매핑 삭제
  Future<void> deleteSubmissionStatus(int formSeq) async {
    await _dbHelper.deleteMapping(formSeq);
  }
}

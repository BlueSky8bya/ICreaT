import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';
import 'package:icreat_dct/0_data/model/type/request_result.dart';
import 'package:icreat_dct/2_repository/dto/epro/epro_schedule_res.dart';
import 'package:icreat_dct/2_repository/icreat_repository.dart';
import 'package:icreat_dct/2_repository/pref_repository.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class ScheduleService {
  final IcreatRepository _icreatRepo;
  final PrefRepository _prefRepo;

  ScheduleService(
    this._icreatRepo,
    this._prefRepo,
  );

  Future<RequestResult<EproScheduleModel>> getScheduleList({
    required DateTime from,
    required DateTime to,
  }) => handleRequest(() async {
    final studyNo = _prefRepo.projectId ?? '';
    final pid = _prefRepo.pid ?? '';
    final orgCd = _prefRepo.organCode ?? '';

    final result = await _icreatRepo.getScheduleList(
      studyNo: studyNo,
      pid: pid,
      orgCd: orgCd,
      from: from.toYMD(),
      to: to.toYMD(),
    );

    return result.toModel();
  });

  Future<RequestResult<bool>> updateVisitStatus({
    required String studyeventDataSeq,
    required DateTime visitDate,
  }) => handleRequest(() async {
    final pid = _prefRepo.pid ?? '';
    final result = await _icreatRepo.updateVisitDate(
      pid: pid,
      studyeventDataSeq: studyeventDataSeq,
      visitDate: visitDate.toYMD(),
    );

    return result.isSuccess;
  });
}

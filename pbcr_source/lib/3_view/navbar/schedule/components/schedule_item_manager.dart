import 'package:get/get.dart';

import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';
import 'package:icreat_dct/0_data/model/esource/esource_submission_status.dart';
import 'package:icreat_dct/1_service/esource_service.dart';
import 'package:icreat_dct/1_service/project_service.dart';
import 'package:icreat_dct/1_service/schedule_service.dart';
import 'package:icreat_dct/3_view/data/async_state.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

class ScheduleItemManager {
  final Map<String, List<ScheduleItemModel>> _scheduleMap = {}; // key = yyyyMMdd
  //final Map<String, EsourceStatus> _scheduleStatus = {}; // key == uniquekey
  final Rx<AsyncState> _loadingStatus = AsyncState.initial.obs;

  ProjectService? _projectService;
  ScheduleService? _scheduleService;
  EsourceService? _esourceService;

  void init(ProjectService projectService, ScheduleService scheduleService,
      EsourceService esourceService) {
    _projectService = projectService;
    _scheduleService = scheduleService;
    _esourceService = esourceService;
  }

  Rx<AsyncState> get loadingStatus => _loadingStatus;

  //Map<String, EsourceStatus> get scheduleStatus => _scheduleStatus;

  Future<(bool, EsourceStatus, bool, bool)> updateStatusOne(ScheduleItemModel s) async {
    final (status, okOnLocal, okOnRemote) = await _esourceService!.getUpdatedSubmissionStatus(
      s.studyEventSeq,
      s.formSeq,
      s.studyEventName,
      s.formName,
    );

    bool isUpdated = false;

    if (s.esourceStatus != null) {
      EsourceStatus? fromStatus = s.esourceStatus;
      EsourceStatus? toStatus;

      if (okOnLocal) {
        if (okOnRemote) {
          toStatus = status;
        } else {
          toStatus = EsourceStatus.pending;
        }
      }

      if (toStatus != null && fromStatus != toStatus) {
        s.esourceStatus = toStatus;
        isUpdated = true;
      }

    } else {
      if (okOnLocal) {
        if (okOnRemote) {
          s.esourceStatus = status;
        } else {
          s.esourceStatus = EsourceStatus.pending; // to show as 검토중
        }
        isUpdated = true;
      }
    }

    return (isUpdated, status, okOnLocal, okOnRemote);
  }

  Future<int> updateStatus(DateTime date) async {
    //Logger.debug("updateStatus date=$date");

    final dateKey = date.toYMD();
    if (_esourceService == null || !_scheduleMap.containsKey(dateKey)) {
      return 0;
    }

    int updated = 0;
    for (var s in _scheduleMap[dateKey]!) {
      final (isUpdated, _, _, _) = await updateStatusOne(s);
      if (isUpdated) {
        updated++;
      }
    }

    return updated;
  }

  Future<void> fetchAllSchedule([bool? reset]) async {
    final startDate =
        _projectService?.projectInfo?.startDateTime ?? DateTime.now();
    final endDate = _projectService?.projectInfo?.endDateTime ?? DateTime.now();
    await fetchScheduleRange(startDate, endDate, reset);
  }

  Future<void> fetchSchedule(DateTime date, [bool? reset]) async {
    await fetchScheduleRange(date, date, reset);
  }

  Future<void> fetchScheduleRange(DateTime start, DateTime end,
      [bool? reset]) async {
    if (_scheduleService == null) {
      return;
    }

    _loadingStatus.value = AsyncState.loading;
    final resp = await _scheduleService?.getScheduleList(
      from: start,
      to: end,
    );

    final result = resp?.getOrNull();
    if (result == null) {
      _loadingStatus.value = AsyncState.error;
      return;
    }

    _loadingStatus.value = AsyncState.loaded;

    if (reset != null && reset) {
      for (var d = start; d.isBefore(end); d = d.add(const Duration(days: 1))) {
        _scheduleMap.remove(d.toYMD());
      }
    }

    updateSchedule(result.scheduleList);
  }

  List<ScheduleItemModel> getScheduleList(DateTime date) {
    final dateKey = date.toYMD();
    if (_scheduleMap.containsKey(dateKey)) {
      return _scheduleMap[dateKey] ?? [];
    }

    return [];
  }

  void updateSchedule(List<ScheduleItemModel> scheduleList) {
    for (final s in scheduleList) {
      final dateKey = s.plannedDate.toYMD();
      if (_scheduleMap.containsKey(dateKey)) {
        int foundIndex = _scheduleMap[dateKey]
                ?.indexWhere((el) => el.uniqueKey == s.uniqueKey) ??
            -1;
        if (foundIndex < 0) {
          // not found
          _scheduleMap[dateKey]?.add(s);
        } else {
          _scheduleMap[dateKey]?.removeAt(foundIndex);
          _scheduleMap[dateKey]?.insert(foundIndex, s);
        }
      } else {
        _scheduleMap[dateKey] = [s];
      }
    }
  }
}

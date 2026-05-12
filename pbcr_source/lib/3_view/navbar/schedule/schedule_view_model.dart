import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:type_caster/type_caster.dart';

import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';
import 'package:icreat_dct/0_data/model/type/crud_type.dart';
import 'package:icreat_dct/1_service/esource_service.dart';
import 'package:icreat_dct/1_service/project_service.dart';
import 'package:icreat_dct/1_service/schedule_service.dart';
import 'package:icreat_dct/3_view/form/form_view_type.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/3_view/data/async_state.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/6_util/cmn_throttler.dart';
import 'package:icreat_dct/6_util/toast_util.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

import 'components/schedule_item_manager.dart';

enum ScheduleFilter {
  all, // 전체
  submitted, // 제출됨
  notSubmitted, // 미제출
  pending, // 검토중
  redo, // 재수행
}

class Period {
  DateTime start;
  DateTime end;

  Period({
    required this.start,
    required this.end,
  });

  int get numDays => end.difference(start).inDays;
}

class ScheduleViewModel extends BaseViewModel {
  final ProjectService _projectService;
  final ScheduleService _scheduleService;
  final EsourceService _esourceService;

  ScheduleViewModel(
    this._projectService,
    this._scheduleService,
    this._esourceService,
  );

  final Lock _onTapLock = Lock();
  final _scheduleThrottler = CMNThrottler();

  // finally selected, if it is changed, currentPage will be updated
  final Rx<DateTime> _selectedDate = DateTimeExt.getToday().obs;
  final Rx<DateTime> _focusedDate = DateTimeExt.getToday().obs; // temporary selected
  final Rx<ScheduleFilter> _selectedFilter = ScheduleFilter.all.obs;
  final Rx<int> _updateCount = 0.obs;

  final ScheduleItemManager _scheduleItemManager = ScheduleItemManager();
  late PageController pageController;
  int pageIndexInTrace = 0;

  final PageStorageKey _pageStorageKey = PageStorageKey('schedule_page');

  PageStorageKey get pageStorageKey => _pageStorageKey;

  Period get schedulePeriod {
    DateTime startDate = _projectService.projectInfo?.startDateTime ?? DateTime.now();
    DateTime endDate = _projectService.projectInfo?.endDateTime ?? DateTime.now();
    if (isSameDay(startDate, endDate)) {
      endDate = endDate.addDays(365); // after 1 year
    } else {
      endDate = endDate.addDays(31); // added more 31 days
    }

    return Period(start: startDate, end: endDate);
  }

  int get pageCount => schedulePeriod.numDays + 1;

  DateTime get selectedDate => _selectedDate.value;
  DateTime get focusedDate => _focusedDate.value;
  ScheduleFilter get selectedFilter => _selectedFilter.value;
  String get scheduleListUpdateKey => "ScheduleCal-${_updateCount.value}";
  AsyncState get loadingStatus => _scheduleItemManager.loadingStatus.value;

  @override
  void onInit() async {
    super.onInit();

    debounce(_selectedDate, (date) async {
      final updated = await _scheduleItemManager.updateStatus(date);
      if (updated > 0) {
        _updateCount.value++;
      }
    }, time: const Duration(milliseconds: 500));

    DateTime firstDate = DateTime.now();

    pageController = PageController(
      initialPage: firstDate.difference(schedulePeriod.start).inDays,
    );

    _scheduleItemManager.init(_projectService, _scheduleService, _esourceService);
    await _scheduleItemManager.fetchAllSchedule(); // fetch all schedule due to red dots in calendar

    _selectedDate.value = firstDate; // it will trigger updateStatus
    _focusedDate.value = firstDate;

    completeInit();
  }

  DateTime getScheduleDate(int index) => schedulePeriod.start.add(Duration(days: index));

  List<ScheduleItemModel> getScheduleListInPage(int pageIndex) {
    //Logger.debug("scheduleListInPage pageIndex=$pageIndex");
    final date = schedulePeriod.start.add(Duration(days: pageIndex));
    final scheduleList = _scheduleItemManager.getScheduleList(date);

    // filter
    switch (selectedFilter) {
      case ScheduleFilter.all:
        return scheduleList;
      case ScheduleFilter.submitted: // 완료
        return scheduleList.where((el) => el.status.isSubmitted).toList();
      case ScheduleFilter.notSubmitted: // 미제출
        return scheduleList.where((el) => el.status.isNotSubmitted).toList();
      case ScheduleFilter.pending: // 검토중
        return scheduleList.where((el) => el.status.isPending).toList();
      case ScheduleFilter.redo: // 재수행
        return scheduleList.where((el) => el.status.isRequestedRedo).toList();
    }
  }

  /// 일정 방문처리
  Future<bool> _visitSchedule(ScheduleItemModel schedule) async {
    final result = await _scheduleService.updateVisitStatus(
      studyeventDataSeq: schedule.studyEventDataSeq.toString(),
      visitDate: DateTime.now(),
    );

    return result.isSuccess() && result.getOrNull() == true;
  }

  /* 일정 관련 함수 */

  /// `date` 날짜의 스케줄 리스트를 반환
  List<ScheduleItemModel> getSchedules(DateTime date) {
    //Logger.debug("getSchedules date=$date");
    return _scheduleItemManager.getScheduleList(date);
  }

  /* 사용자 액션 관련 함수 */

  // in week calendar

  void onFocusedDayChangedWeek(DateTime date) {
    _focusedDate.value = date.toLocalize();
  }

  void onDaySelectedWeek(DateTime date) {
    _focusedDate.value = date.toLocalize();
    _selectedDate.value = date.toLocalize();
    movePageToSelectedDate();
  }

  void onTapToday() {
    _focusedDate.value = DateTime.now().toLocalize();
    _selectedDate.value = _focusedDate.value;
    movePageToSelectedDate();
  }

  // in bottom month calendar

  void onFocusedDayChanged(DateTime date) {
    _focusedDate.value = date.toLocalize();
  }

  void onDaySelected(DateTime date) {
    _focusedDate.value = date.toLocalize();
  }

  void onTapDateSelected() {
    _selectedDate.value = _focusedDate.value;
    movePageToSelectedDate();
  }

  void movePageToSelectedDate() {
    int targetPageIndex = _selectedDate.value.difference(schedulePeriod.start).inDays;
    if (targetPageIndex < 0) {
      return;
    }

    if (pageIndexInTrace != targetPageIndex) {
      pageController.animateToPage(
        targetPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onSelectScheduleFilter(Set<ScheduleFilter> selectedFilters) {
    if (selectedFilters.isNotEmpty) {
      _selectedFilter.value = selectedFilters.first;
    }
  }

  void onPageChanged(int pageIndex) {
    EasyDebounce.debounce('onPageChanged', const Duration(milliseconds: 700), () {
      pageIndexInTrace = pageIndex; // trace pageController's page

      final date = schedulePeriod.start.add(Duration(days: pageIndex));

      // due to swipe, it must update selected date
      if (!DateUtils.isSameDay(date, _selectedDate.value)) {
        _selectedDate.value = date; // it will trigger updateStatus
        _focusedDate.value = date;
        // no need to move page
      }
    });
  }

  Future<void> onRefresh() async {
    await _scheduleItemManager.fetchSchedule(_selectedDate.value);
    final updated = await _scheduleItemManager.updateStatus(_selectedDate.value);
    if (updated > 0) {
      _updateCount.value++;
    }
  }

  Future<void> onRefreshSchedule(ScheduleItemModel schedule) async {
    final (updated, _, _, _) = await _scheduleItemManager.updateStatusOne(schedule);
    if (updated) {
      _updateCount.value++;
    }
  }

  void onTapSchedule(BuildContext context, {required ScheduleItemModel schedule}) {
    _scheduleThrottler.run(() {
      _onTapLock.synchronized(() async {
        await handleSchedule(context, schedule: schedule);
      });
    });
  }

  Future<void> handleSchedule(BuildContext context, {required ScheduleItemModel schedule}) async {
    /// 경우의 수를 생각해보자
    ///
    /// 1. 제출한 문진을 읽는 경우
    /// 2. 미제출이라서 제출을 확인해야하는 경우
    /// 2-1. 방문 등록이 된 경우
    /// 2-2. 방문 등록이 되지 않은 경우
    ///
    /// 그럼 순서가
    ///
    /// 제출된 문진인가?
    /// Y -> 읽기 전용 폼으로 이동
    /// (미제출 동작)
    /// N -> 일정 수행이 가능한가?(편차 일정 이내인 경우)
    /// Y -> 방문 처리된 일정인가?
    /// N -> 방문 처리 API 호출
    ///
    ///
    ///

    if (schedule.isSubmitted) {
      await _navigateToForm(context, schedule: schedule, crudType: CrudType.read);
      await onRefresh();
      return;
    }

    if (!schedule.isInPlannedDateRange) {
      if (schedule.isForFuture) {
        ToastUtil.showToast('향후 수행 가능한 일정입니다.');
      } else {
        ToastUtil.showToast('이미 지난 일정입니다.');
      }
      return;
    }

    if (!schedule.hasVisited) {
      final success = await _visitSchedule(schedule);
      if (!success) {
        ToastUtil.showToast('일정을 불러오는데 실패했습니다. 연구진에 문의해주세요.');
        return;
      }
      //_scheduleItemManager.fetchSchedule(schedule.plannedDate);
    }

    if (!context.mounted) {
      return;
    }

    CrudType crudType = schedule.scheduleCrudType;

    final (_, status, okOnLocal, okOnRemote) = await _scheduleItemManager.updateStatusOne(schedule);
    if (okOnLocal && okOnRemote) {
      if (status.isRejected || status.isError) {
        ToastUtil.showToast('연구진이 재수행을 요청했습니다.');
      } else if (status.isApproved) {
        if (!schedule.status.isSubmitted) {
          // schedule 상태가 아직 업데이트 되지 않음
          ToastUtil.showToast('연구진이 승인했습니다. 새로고침 후 작성한 내용을 확인해주세요.');
          return;
        }

        crudType = CrudType.read; // 읽기 전용, 재수행 불가
      }
    }

    if (context.mounted) {
      await _navigateToForm(context, schedule: schedule, crudType: crudType);
      await onRefreshSchedule(schedule); // when form close
    }
  }

  Future<void> _navigateToForm(BuildContext context, {
    required ScheduleItemModel schedule,
    required CrudType crudType,
  }) async {
    await CommonNavigator.toForm(context,
      option: FormViewModelOption(
        studyOid: _projectService.projectInfo?.studyNo ?? '',
        studyEventSeq: schedule.studyEventSeq.toString(),
        studyEventDataSeq: schedule.studyEventDataSeq.toString(),
        studyEventName: schedule.studyEventName,
        formSeq: schedule.formSeq.toString(),
        formVersionSeq: schedule.formVersionSeq.toString(),
        formDataSeq: schedule.formDataSeq.toString(),
        formName: schedule.formName,
        dateKey: schedule.plannedDate,
        crudType: crudType,
        scheduledAt: schedule.plannedDate,
      )
    );
  }
}

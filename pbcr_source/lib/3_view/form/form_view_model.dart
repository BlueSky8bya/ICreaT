import 'dart:async';

import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:type_caster/type_caster.dart';

import 'package:icreat_dct/0_data/model/health/daily_sleep_record.dart';
import 'package:icreat_dct/0_data/model/health/daily_step_record.dart';
import 'package:icreat_dct/0_data/model/type/crf_input_type.dart';
import 'package:icreat_dct/0_data/model/type/crud_type.dart';
import 'package:icreat_dct/1_service/crf_service.dart';
import 'package:icreat_dct/1_service/esource_service.dart';
import 'package:icreat_dct/1_service/health_service.dart';
import 'package:icreat_dct/1_service/measurement_service.dart';
import 'package:icreat_dct/1_service/project_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/3_view/components/dialog/confirm_dialog.dart';
import 'package:icreat_dct/3_view/form/util/form_answer_queue.dart';
import 'package:icreat_dct/3_view/form/util/form_status_manager.dart';
import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/4_router/common_navigator.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/6_util/toast_util.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';

import 'components/form_review_dialog.dart';
import 'form_view_type.dart';
import 'util/form_validator.dart';


class FormViewModel extends BaseViewModel {
  final BuildContext _context;
  final FormViewModelOption _formOption;

  final CRFService _eCRFService;
  final MeasurementService _measurementService;
  final HealthService _healthService;
  final EsourceService _esourceService;
  final ProjectService _projectService;

  final FormAnswerQueueManager _answerQueueManager = FormAnswerQueueManager();

  int? _listenerIdForMeasurement;

  // managers

  final FormStatusManager _formStatusManager = FormStatusManager();
  final FormValidator _formValidator = FormValidator();
  final PageController _pageController = PageController();

  FormViewModel(
    this._context,
    this._formOption,
    this._eCRFService,
    this._measurementService,
    this._healthService,
    this._esourceService,
    this._projectService,
  );

  // service functions to use sub-widgets

  String? getAnswer(String key) {
    return _formStatusManager.getCurrentAnswer(key);
  }

  TextEditingController getTextController(String key) {
    return _formStatusManager.textController(key);
  }

  List<FormQuestion> getQuestionListByGroupIndex(int index) {
    return _formStatusManager.getFormQuestionListByGroupIndex(index);
  }

  (String, String) getSectionTitleDesc(int index) {
    return _formStatusManager.getSectionTitleDesc(index);
  }

  bool isMandatory(String key) {
    return _formStatusManager.isEnabled(key) && _formValidator.isMandatory(key);
  }


  final RxInt _currentPageIndex = 0.obs;
  final RxBool _isHorizontalScroll = true.obs;
  final RxSet<String> _enabledQuestionSet = RxSet();
  final RxInt _sectionWidgetCount = 0.obs;
  final RxInt _numQuestion = 0.obs;
  final RxInt _numAnswer = 0.obs;
  final RxString _submitButtonText = "검토 및 제출".obs;
  final RxString _highlightedItemUid = "".obs;

  // getters

  PageController get pageController => _pageController;
  Set<String> get enabledQuestionSet => _enabledQuestionSet;
  String get sectionWidgetKey => "FormSection#${_sectionWidgetCount.value}";
  int get numPage => _formStatusManager.numPage;
  bool get isHorizontalScroll => _isHorizontalScroll.value;
  int get currentPageIndex => _currentPageIndex.value;
  bool get isFirstPage => currentPageIndex == 0;
  bool get isLastPage => currentPageIndex == numPage - 1;
  bool get isReadOnly => _formOption.crudType == CrudType.read;
  int get numQuestion => _numQuestion.value;
  int get numTotalQuestion => _formStatusManager.numTotalQuestion;
  int get numAnswer => _numAnswer.value;
  String get submitButtonText => _submitButtonText.value;
  String get highlightedItemUid => _highlightedItemUid.value;

  @override
  void onInit() async {

    super.onInit();

    // init listener
    _listenerIdForMeasurement = _measurementService.addEvent(onReceiveMeasurement);

    // init page controller
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        final newPageIndex = _pageController.page?.round() ?? 0;
        if (newPageIndex != _currentPageIndex.value) {
          _currentPageIndex.value = newPageIndex;
        }
      }
    });

    // fetch eCRF from iCReaT DCT
    final resp = await _eCRFService.fetchCRF(
      formSeq: _formOption.formSeq,
      formVersionSeq: _formOption.formVersionSeq,
      formDataSeq: _formOption.formDataSeq,
    );

    final eCRF = resp.getOrNull(); // if error it return null;
    if (eCRF != null) {

      // form validator
      final validationResp = await _eCRFService.fetchCRFValidation(
        formSeq: _formOption.formSeq,
        formVersionSeq: _formOption.formVersionSeq,
      );

      if (!isReadOnly) {
        _formValidator.setReservedMap({
          // TODO: add more reserved words here
          "{TODAY}": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        });

        _scheduleHourlyTask(() {
          _formValidator.updateReservedMap(
              "{TODAY}", DateFormat('yyyy-MM-dd').format(DateTime.now()));
        });
      }

      final editCheckList = validationResp.getOrNull();
      if (editCheckList != null) {
        _formValidator.setCheckList(editCheckList.list);
      }

      // form status manager
      final (summList, prevAnswerMap) = _formStatusManager.init(
        eCRF.itemGroupList,
        _formValidator.getDefaultDisabledItemList(),
      );

      // update overlayEnabled according to previous answers

      for (var summ in summList) {
        var result = _formValidator.checkEnable(
          itemUid: summ.itemUid,
          input: summ.answer,
          dataType: summ.dataType,
          inputType: summ.inputType,
          inputMap: prevAnswerMap,
        );

        if (result.hasChangedItem) {
          _formStatusManager.updateOverlayEnabledList(
            summ.itemUid,
            enabledList: result.enabled,
            disabledList: result.disabled,
          );
        }
      }

      final enabledList = _formStatusManager.getEnabledItemUidList();
      _numQuestion.value = enabledList.length;

      //_enabledQuestionSet.clear();
      _enabledQuestionSet.addAll(enabledList);
      _sectionWidgetCount.value++;
    }

    completeInit();
  }

  @override
  void onClose() {
    _formStatusManager.disposeTextControllers();
    _measurementService.removeEvent(_listenerIdForMeasurement);
    super.onClose();
  }

  void _scheduleHourlyTask(VoidCallback callback) {
    final now = DateTime.now();
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0);
    final initialDelay = nextHour.difference(now);

    Timer(initialDelay, () {
      callback.call();
      Timer.periodic(Duration(hours: 1), (timer) {
        callback.call();
      });
    });
  }

  // event handlers

  void onReceiveMeasurement(MeasurementServiceEvent event) async {

    /// 이벤트를 받으면
    /// 1. event의 itemGroupKey와 일치하는 아이템 목록 가져오기
    /// 2. 그중에서 MeasurementType과 CrfItemModel의 CrfInputType이 일치하는 아이템 찾기
    /// 3. 찾은 아이템의 key를 받아서 답변 업데이트
    /// 4. 위 과정을 반복하면서 모든 아이템의 답변을 업데이트
    /// 예외. itemGroupKey에 보통 무조건 CrfInputType은 유니크하게 1개만 존재
    /// 하지만 여러개 존재할경우 첫번째 아이템의 답변을 업데이트
    ///
    Logger.info('receiveMeasurement: $event');

    // 1. itemGroupKey와 일치하는 아이템 목록 가져오기
    final subFormQuestionList = _formStatusManager.getFormQuestionListByGroup(event.itemGroupUid);

    // 2. MeasurementType과 CrfInputType이 일치하는 아이템 찾기
    switch (event.measurementType) {
      case MeasurementType.bloodPressure:
        final systolicSelect = subFormQuestionList.firstWhereOrNull((el) => el.model.inputType == CrfInputType.measurementBpSys);
        final diastolicSelect = subFormQuestionList.firstWhereOrNull((el) => el.model.inputType == CrfInputType.measurementBpDia);
        final pulseSelect = subFormQuestionList.firstWhereOrNull((el) => el.model.inputType == CrfInputType.measurementBpPulse);

        _answerQueueManager.push(systolicSelect?.key ?? "", event.data['systole']);
        _answerQueueManager.push(diastolicSelect?.key ?? "", event.data['diastole']);
        _answerQueueManager.push(pulseSelect?.key ?? "", event.data['pulse']);
        procAnswerQueue();
        break;

      case MeasurementType.bodyWeight:
        final select = subFormQuestionList.firstWhereOrNull((el) => el.model.inputType == CrfInputType.measurementBodyWeight);
        _answerQueueManager.push(select?.key ?? "", event.data['weight']);
        procAnswerQueue();
        break;

      case MeasurementType.temperature:
        final select = subFormQuestionList.firstWhereOrNull((el) => el.model.inputType == CrfInputType.measurementBodyTemperature);
        _answerQueueManager.push(select?.key ?? "", event.data['temperature']);
        procAnswerQueue();
        break;

      default:
        break;
    }
  }

  void moveToQuestion(String itemUid) {
    _highlightedItemUid.value = itemUid;
    _sectionWidgetCount.value++;
    moveToPage(_formStatusManager.getGroupIndex(itemUid));
  }

  void moveToPrev() {
    if (currentPageIndex > 0) {
      _pageController.animateToPage(
        currentPageIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void moveToNext() {
    if (currentPageIndex < numPage - 1) {
      _pageController.animateToPage(
        currentPageIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void moveToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < numPage && pageIndex != currentPageIndex) {
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void updateQuestionUx() {
    // update RxList to trigger refresh question list

    final enabledList = _formStatusManager.getEnabledItemUidList();
    _numQuestion.value = enabledList.length;
    _numAnswer.value = _formStatusManager.numAnswer;

    _enabledQuestionSet.clear();
    _enabledQuestionSet.addAll(enabledList);
    _sectionWidgetCount.value++;
  }

  void onChangeAnswer(String itemUid, String answer) {
    _answerQueueManager.push(itemUid, answer);
    procAnswerQueue();
  }

  Future<bool> checkSameAnswer(FormQuestion formQuestion, String answer) async {
    var prevAnswer = _formStatusManager.getCurrentAnswer(formQuestion.key);
    if (prevAnswer != null && answer == prevAnswer) {
      return false;
    }

    return true;
  }

  Future<bool> checkItemLength(FormQuestion formQuestion, String answer) async {
    var ok = _formValidator.isValidItemLength(
      answer,
      formQuestion.model.dataType,
      formQuestion.model.itemLength,
    );
    if (!ok) {
      ToastUtil.showToast("입력의 길이가 유효하지 않습니다. (${formQuestion.model.itemLength})");
      return false;
    }

    return true;
  }

  Future<bool> checkWarning(FormQuestion formQuestion, String answer) async {
    var msgOnWarning = _formValidator.checkWarning(
      itemUid: formQuestion.key,
      input: answer,
      dataType: formQuestion.model.dataType,
      inputType: formQuestion.model.inputType,
      inputMap: _formStatusManager.getEnabledAnswerMap()
    );

    if (!msgOnWarning.isNullOrEmpty) {
      ToastUtil.showToast(msgOnWarning!);
    }

    return true;
  }

  Future<bool> checkQuery(FormQuestion formQuestion, String answer) async {

    var msgOnQuery = _formValidator.checkQuery(
      itemUid: formQuestion.key,
      input: answer,
      dataType: formQuestion.model.dataType,
      inputType: formQuestion.model.inputType,
      inputMap: _formStatusManager.getEnabledAnswerMap()
    );

    if (!msgOnQuery.isNullOrEmpty) {
      final completer = Completer<bool>();

      int maxWaitCount = 5;
      Timer.periodic(Duration(milliseconds: 500), (timer) { // to wait close context
        if (_context.mounted) {
          timer.cancel();
          showDialog<String>(
            context: _context,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return ConfirmDialog(
                title: "입력값을 확인해주세요.",
                message: "$msgOnQuery\n\n입력된 값: $answer ${formQuestion.model.measurementUnit ?? ""}",
                ok: "그대로 입력",
                cancel: "입력 취소",
                onOk: () => completer.complete(true),
                onCancel: () => completer.complete(false),
              );
            }
          );
        } else {
          --maxWaitCount;
          Logger.debug("maxWaitCount=$maxWaitCount");
          if (maxWaitCount <= 0) {
            timer.cancel();
            ToastUtil.showToast(msgOnQuery!);
            completer.complete(true);
          }
        }
      });

      return completer.future;
    }

    return true;
  }

  Future<bool> checkError(FormQuestion formQuestion, String answer) async {

    var (hasError, msgOnError) = _formValidator.checkError(
      itemUid: formQuestion.key, // itemUid
      input: answer,
      dataType: formQuestion.model.dataType,
      inputType: formQuestion.model.inputType,
      inputMap: _formStatusManager.getEnabledAnswerMap(),
    );

    if (hasError) {
      if (!msgOnError.isNullOrEmpty) {
        ToastUtil.showToast(msgOnError!);
      }
      return false;
    }

    return true;
  }

  Future<bool> checkEnable(FormQuestion formQuestion, String answer) async {

    var result = _formValidator.checkEnable(
      itemUid: formQuestion.key, // itemUid
      input: answer,
      dataType: formQuestion.model.dataType,
      inputType: formQuestion.model.inputType,
      inputMap: _formStatusManager.getEnabledAnswerMap(),
    );

    _formStatusManager.setAnswer(
      formQuestion.key,
      answer,
      enabled: result.enabled,
      disabled: result.disabled,
    );

    updateQuestionUx();

    return false;
  }

  void procAnswerQueue() {
    Timer(Duration(milliseconds: 500), () {
      _answerQueueManager.processAll(
        fetchFormQuestion: _formStatusManager.getFormQuestionByKey,
        procFuncList: [
          checkSameAnswer,
          checkItemLength,
          checkQuery,
          checkWarning,
          checkError,
          checkEnable
        ]
      );
    });
  }

  Future<(int, String)> handleSubmit() async {

    _highlightedItemUid.value = ""; // reset
    _sectionWidgetCount.value++;

    Logger.debug("handleSubmit");

    // validation

    var ansMap = _formStatusManager.answerMap;

    for (var itemUid in _formStatusManager.orderedUidList) {
      var isEnabled = _formStatusManager.isEnabled(itemUid);
      var answer = ansMap[itemUid] ?? "";
      if (!isEnabled) {
         continue;
      }

      var formQuestion = _formStatusManager.getFormQuestionByKey(itemUid);
      if (formQuestion == null) {
        continue;
      }

      var (hasError, msgOnError) = _formValidator.checkError(
        itemUid: itemUid, // itemUid
        input: answer,
        dataType: formQuestion.model.dataType,
        inputType: formQuestion.model.inputType,
        inputMap: ansMap,
      );

      if (hasError) { // is not valid
        if (!msgOnError.isNullOrEmpty) {
          ToastUtil.showToast(msgOnError!);
        }

        return (-1, itemUid);
      }
    }

    // answer submit to eSource

    final (request, serviceUUID) = _formStatusManager.toEsourceRequest(
      studyOid: _projectService.projectId,
      siteId: _projectService.organCode,
      personId: _projectService.subjectId,
      personNm: _projectService.subjectName,
      visitOccurrenceId: _formOption.studyEventName,
      visitDetailId: '1', // 이건 1로 그냥 두면 됨
      formName: _formOption.formName,
    );

    // eSource에 업로드하고 로컬 DB에 매핑 저장

    final statusId = await _esourceService.submit(
      request,
      serviceUUID,
      asInt(_formOption.formSeq, orElse: () => 0), // formSeq
      asInt(_formOption.studyEventSeq, orElse: () => 0), // studyEventSeq
      _formOption.studyEventName,
      _formOption.formName,
    );

    return (statusId, "");
  }

  void onTapPreview() {
    if (isReadOnly) {
      return;
    }

    _submitButtonText.value = "정리 중...";
    EasyDebounce.debounce('submit-debouncer', Duration(milliseconds: 700), () {
      _submitButtonText.value = "검토 및 제출";

      var answerList = _formStatusManager.getAnswerListForPreview();
      for (var section in answerList) {
        for (var question in section.itemList) {
          question.isMandatory = _formValidator.isMandatory(question.itemUid);
        }
      }

      showDialog<String>(
        context: _context,
        builder: (BuildContext dialogContext) {
          return FormReviewDialog(
            context: dialogContext,
            answerList: answerList,
            onSubmit: () async {
              var (statusId, itemUid) = await handleSubmit();
              if (statusId > 0) {
                ToastUtil.showToast('제출에 성공하였습니다. 연구자가 승인 대기 중입니다.');
                Timer(const Duration(seconds: 1), () {
                  Navigator.pop(_context); // move to schedule list
                });
              } else {
                if (itemUid.isEmpty) {
                  ToastUtil.showToast('제출에 실패하였습니다.');
                } else {
                  ToastUtil.showToast('입력이 잘못되었습니다.');
                  Timer(const Duration(seconds: 1), () {
                    moveToQuestion(itemUid);
                  });
                }
              }
            },
            onCancel: () {
            },
          );
        }
      );
    });
  }

  void onPressedRotButton() {
    if (_isHorizontalScroll.value) {
      _isHorizontalScroll.value = false;
    } else {
      _isHorizontalScroll.value = true;
    }
  }

  void onTapFormQuestion(String key) {
    final formQuestion = _formStatusManager.getFormQuestionByKey(key);
    if (formQuestion != null && formQuestion.type == FormSelectType.measurement) {
      switch (formQuestion.model.inputType) {
        case CrfInputType.measurementBpSys:
        case CrfInputType.measurementBpDia:
        case CrfInputType.measurementBpPulse:
          CommonNavigator.toMeasurementSelect(
            _context,
            measurementType: MeasurementType.bloodPressure,
            itemGroupKey: formQuestion.model.itemGroupUid,
          );
          break;
        case CrfInputType.measurementBodyTemperature:
          CommonNavigator.toMeasurementSelect(
            _context,
            measurementType: MeasurementType.temperature,
            itemGroupKey: formQuestion.model.itemGroupUid,
          );
          break;
        case CrfInputType.measurementBodyWeight:
          CommonNavigator.toMeasurementSelect(
            _context,
            measurementType: MeasurementType.bodyWeight,
            itemGroupKey: formQuestion.model.itemGroupUid,
          );
          break;
        case CrfInputType.measurementSleepStart:
          showProgress();
          fillSleepStartTime(key).then((_) {
            dismissProgress();
          });
          break;
        case CrfInputType.measurementSleepEnd:
          showProgress();
          fillSleepEndTime(key).then((_) {
            dismissProgress();
          });
          break;
        case CrfInputType.measurementSleepDuration:
          showProgress();
          fillSleepDuration(key).then((_) {
            dismissProgress();
          });
          break;
        case CrfInputType.measurementStep:
          showProgress();
          fillStepRecord(key).then((_) {
            dismissProgress();
          });
          break;
        default:
      }
    }
  }


  Future<DailyStepRecord?> fetchStepRecord(DateTime scheduledAt) async {
    final stepRecord = await _healthService.getStepRecordsForPeriod(
      scheduledAt.withStartTime(),
      scheduledAt.withEndTime(),
    );
    return stepRecord.firstOrNull;
  }

  /// 수면 데이터는 보통 전날 수면을 가지므로 전날 자정부터 오늘 자정까지 데이터를 가져옴
  Future<DailySleepRecord?> fetchSleepRecord(DateTime scheduledAt) async {
    final sleepRecord = await _healthService.getSleepRecordsForPeriod(
      scheduledAt.subtract(const Duration(days: 1)).withStartTime(),
      scheduledAt.withEndTime(),
    );
    return sleepRecord.firstOrNull;
  }

  Future<void> fillStepRecord(String key) async {
    final stepRecord = await fetchStepRecord(_formOption.scheduledAt);
    if (stepRecord != null) {
      onChangeAnswer(key, stepRecord.totalStepCount.toString());
    }
  }

  Future<void> fillSleepRecord(String key) async {
    final sleepRecord = await fetchSleepRecord(_formOption.scheduledAt);
    if (sleepRecord != null) {
      onChangeAnswer(key, sleepRecord.totalSleepMinutes.toString());
    }
  }


  Future<void> fillSleepStartTime(String key) async {
    final sleepRecord = await fetchSleepRecord(_formOption.scheduledAt);
    if (sleepRecord != null && sleepRecord.validSleepData.isNotEmpty) {
      onChangeAnswer(key, sleepRecord.validSleepData.first.startTime.toHM());
    }
  }

  Future<void> fillSleepEndTime(String key) async {
    final sleepRecord = await fetchSleepRecord(_formOption.scheduledAt);
    if (sleepRecord != null && sleepRecord.validSleepData.isNotEmpty) {
      onChangeAnswer(key, sleepRecord.validSleepData.last.endTime.toHM());
    }
  }

  Future<void> fillSleepDuration(String key) async {
    final sleepRecord = await fetchSleepRecord(_formOption.scheduledAt);
    if (sleepRecord != null) {
      onChangeAnswer(key, sleepRecord.totalSleepMinutes.toString());
    }
  }
}

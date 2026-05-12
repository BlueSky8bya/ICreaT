import 'package:icreat_dct/0_data/model/epro/epro_form_status.dart';
import 'package:icreat_dct/0_data/model/esource/esource_submission_status.dart';
import 'package:icreat_dct/0_data/model/type/crud_type.dart';
import 'package:icreat_dct/3_view/components/badge/badge_color.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';

enum EproStatus {
  notSubmitted,
  inReview,
  requestedRedo,
  completed,
  completedSecure
}

class ScheduleStatus {
  final FormStatus formStatus;
  final EsourceStatus? esourceStatus;

  ScheduleStatus({
    required this.formStatus,
    this.esourceStatus,
  });

  bool get isEditable { // 수정 가능
    if (esourceStatus != null) {
      if (esourceStatus!.isPending || esourceStatus!.isRejected) {
        return true;
      }
      if (esourceStatus!.isApproved) {
        return false;
      }
    }

    return formStatus.isEditable;
  }

  bool get isSubmitted { // 제출 완료
    if (esourceStatus != null && esourceStatus!.isApproved) { // not updated yet
      return true;
    }

    return formStatus.isCompleted;
  }

  bool get isNotSubmitted { // 미제출
    return !formStatus.isCompleted  && (esourceStatus == null || esourceStatus!.isNull || esourceStatus!.isError);
  }

  bool get isRequestedRedo { // 재수행
    return !formStatus.isCompleted && esourceStatus != null && esourceStatus!.isRejected;
  }

  bool get isPending { // 검토 중

    // WARN:
    // there is not such form status 'pending' from server
    // pending is the status of we have a record of submission

    if (esourceStatus != null && esourceStatus!.isPending) {
      return true;
    }

    return formStatus.isPending;
  }

  EproStatus get eproStatus {

    // TODO: we dont know all the cases. if found additional case, apply it

    if (formStatus.isCompleted) {
      return EproStatus.completed;
    }

    if (isPending) {
      return EproStatus.inReview;
    }

    if (formStatus == FormStatus.ready) {
      switch(esourceStatus) {
        case null:
        case EsourceStatus.nil:
        case EsourceStatus.transmissionError:
        case EsourceStatus.dataError:
          return EproStatus.notSubmitted;
        case EsourceStatus.pending:
          return EproStatus.inReview;
        case EsourceStatus.rejected:
          return EproStatus.requestedRedo;
        case EsourceStatus.approved:
          return EproStatus.completed;
        case EsourceStatus.securityApproved:
          return EproStatus.completedSecure;
      }
    }

    return EproStatus.notSubmitted;
  }

  String get label {
    switch(eproStatus) {
      case EproStatus.notSubmitted:
        return "미제출";
      case EproStatus.inReview:
        return "검토중";
      case EproStatus.requestedRedo:
        return "재수행";
      case EproStatus.completed:
        return "제출";
      case EproStatus.completedSecure:
        return "제출";
    }
  }

  BadgeColor get badgeColor {
    switch(eproStatus) {
      case EproStatus.notSubmitted:
        return BadgeColor.grey;
      case EproStatus.inReview:
        return BadgeColor.orange;
      case EproStatus.requestedRedo:
        return BadgeColor.red;
      case EproStatus.completed:
        return BadgeColor.blue;
      case EproStatus.completedSecure:
        return BadgeColor.green;
    }
  }
}


class EproScheduleModel {
  final List<ScheduleItemModel> scheduleList;
  final String resultValue;

  EproScheduleModel({
    required this.scheduleList,
    required this.resultValue,
  });
}

class ScheduleItemModel {
  final int studyEventSeq;
  final String studyEventName;
  final String eventStatus;
  final String isNew;
  final int studyEventRepeatKey;
  final int visitSeq;
  final int formSeq;
  final String formName;
  final String noForm;
  final int formVersionSeq;
  final String fvStatus;
  final String formRepeating;
  final int formRepeatKey;
  final int feSeq;
  final int visitOrder;
  final String eventCycle;
  final String eventInterval;
  final String eventType;
  final int prevStudyEventOid;
  final String scheduleYn;
  final DateTime plannedDate;
  final DateTime? minPlannedDate;
  final DateTime? maxPlannedDate;
  final String? visitDate;
  final String pastYn;
  final String visitYn;
  final String formStatus;
  final String? crfDate;
  final String nrYn;
  final int formDataSeq;
  final int studyEventDataSeq;
  final String mandatory;
  final int formCnt;
  late EsourceStatus? esourceStatus; // eSource 상태 정보, 업데이트 가능

  ScheduleItemModel({
    required this.studyEventSeq,
    required this.studyEventName,
    required this.eventStatus,
    required this.isNew,
    required this.studyEventRepeatKey,
    required this.visitSeq,
    required this.formSeq,
    required this.formName,
    required this.noForm,
    required this.formVersionSeq,
    required this.fvStatus,
    required this.formRepeating,
    required this.formRepeatKey,
    required this.feSeq,
    required this.visitOrder,
    required this.eventCycle,
    required this.eventInterval,
    required this.eventType,
    required this.prevStudyEventOid,
    required this.scheduleYn,
    required this.plannedDate,
    required this.minPlannedDate,
    required this.maxPlannedDate,
    this.visitDate,
    required this.pastYn,
    required this.visitYn,
    required this.formStatus,
    this.crfDate,
    required this.nrYn,
    required this.formDataSeq,
    required this.studyEventDataSeq,
    required this.mandatory,
    required this.formCnt,
    this.esourceStatus,
  });

  bool get hasVisited => visitYn == 'Y';

  ScheduleStatus get status {
    return ScheduleStatus(
      formStatus: FormStatus.fromString(formStatus),
      esourceStatus: esourceStatus,
    );
  }

  CrudType get scheduleCrudType {
    //Logger.debug('formDataSeq: $formDataSeq');
    //Logger.debug('formStatusEnum: $status');
    if (formDataSeq == 0) {
      return CrudType.create;
    }

    return status.isEditable ? CrudType.update : CrudType.read;
  }

  bool get isInPlannedDateRange {
    final baseMinDate = minPlannedDate ?? plannedDate;
    final baseMaxDate = maxPlannedDate ?? plannedDate;
    final now = DateTime.now();
    return now.isSameOrAfter(baseMinDate) && now.isSameOrBefore(baseMaxDate);
  }

  bool get isForFuture {
    final baseDate = minPlannedDate ?? plannedDate;
    final now = DateTime.now();
    return now.isBefore(baseDate);
  }

  bool get isSubmitted {
    return status.isSubmitted;
  }

  bool get isPending {
    return status.isPending;
  }

  String get uniqueKey => '$studyEventSeq-$formSeq-$formVersionSeq';

  @override
  String toString() {
    return 'ScheduleItemModel(studyEventSeq: $studyEventSeq, studyEventName: $studyEventName, eventStatus: $eventStatus, isNew: $isNew, studyEventRepeatKey: $studyEventRepeatKey, visitSeq: $visitSeq, formSeq: $formSeq, formName: $formName, noForm: $noForm, formVersionSeq: $formVersionSeq, fvStatus: $fvStatus, formRepeating: $formRepeating, formRepeatKey: $formRepeatKey, feSeq: $feSeq, visitOrder: $visitOrder, eventCycle: $eventCycle, eventInterval: $eventInterval, eventType: $eventType, prevStudyEventOid: $prevStudyEventOid, scheduleYn: $scheduleYn, plannedDate: $plannedDate, minPlannedDate: $minPlannedDate, maxPlannedDate: $maxPlannedDate, visitDate: $visitDate, pastYn: $pastYn, visitYn: $visitYn, formStatus: $formStatus, crfDate: $crfDate, nrYn: $nrYn, formDataSeq: $formDataSeq, studyEventDataSeq: $studyEventDataSeq, mandatory: $mandatory, formCnt: $formCnt)';
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';

part 'epro_schedule_res.g.dart';

bool _stringToBool(String value) => value == 'Y';
String _boolToString(bool value) => value ? 'Y' : 'N';

DateTime? _stringToDateTime(String value) {
  if (value.isEmpty) return null;
  final parts = value.split('-');
  if (parts.length != 3) return null;
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

String _dateTimeToString(DateTime? value) {
  if (value == null) return '';
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

@JsonSerializable()
class EproScheduleRes {
  @JsonKey(name: 'scheduleList')
  final List<ScheduleItem> scheduleList;

  @JsonKey(name: '_RSLT_VAL')
  final String resultValue;

  EproScheduleRes({
    required this.scheduleList,
    required this.resultValue,
  });

  factory EproScheduleRes.fromJson(Map<String, dynamic> json) =>
      _$EproScheduleResFromJson(json);

  Map<String, dynamic> toJson() => _$EproScheduleResToJson(this);
}

@JsonSerializable()
class ScheduleItem {
  @JsonKey(name: 'STUDYEVENT_SEQ')
  final int studyEventSeq;

  @JsonKey(name: 'STUDYEVENT_NAME')
  final String studyEventName;

  @JsonKey(name: 'EVENT_STATUS')
  final String eventStatus;

  @JsonKey(name: 'IS_NEW')
  final String isNew;

  @JsonKey(name: 'STUDYEVENT_REPEATKEY')
  final int studyEventRepeatKey;

  @JsonKey(name: 'VISIT_SEQ')
  final int visitSeq;

  @JsonKey(name: 'FORM_SEQ')
  final int formSeq;

  @JsonKey(name: 'FORM_NAME')
  final String formName;

  @JsonKey(name: 'NO_FORM')
  final String noForm;

  @JsonKey(name: 'FORM_VERSION_SEQ')
  final int formVersionSeq;

  @JsonKey(name: 'FV_STATUS')
  final String fvStatus;

  @JsonKey(name: 'FORM_REPEATING')
  final String formRepeating;

  @JsonKey(name: 'FORM_REPEATKEY')
  final int? formRepeatKey;

  @JsonKey(name: 'FE_SEQ')
  final int feSeq;

  @JsonKey(name: 'VISIT_ORDER')
  final int visitOrder;

  @JsonKey(name: 'EVENT_CYCLE')
  final String eventCycle;

  @JsonKey(name: 'EVENT_INTERVAL')
  final String eventInterval;

  @JsonKey(name: 'EVENT_TYPE')
  final String eventType;

  @JsonKey(name: 'PREV_STUDYEVENT_OID')
  final int prevStudyEventOid;

  @JsonKey(name: 'SCHEDULE_YN')
  final String scheduleYn;

  @JsonKey(
    name: 'PLANNED_DATE',
    fromJson: _stringToDateTime,
    toJson: _dateTimeToString,
  )
  final DateTime? plannedDate;

  @JsonKey(
    name: 'MIN_PLANNED_DATE',
    fromJson: _stringToDateTime,
    toJson: _dateTimeToString,
  )
  final DateTime? minPlannedDate;

  @JsonKey(
    name: 'MAX_PLANNED_DATE',
    fromJson: _stringToDateTime,
    toJson: _dateTimeToString,
  )
  final DateTime? maxPlannedDate;

  @JsonKey(name: 'VISIT_DATE')
  final String? visitDate;

  @JsonKey(
    name: 'PAST_YN',
    fromJson: _stringToBool,
    toJson: _boolToString,
  )
  final bool pastYn;

  @JsonKey(name: 'VISIT_YN')
  final String visitYn;

  @JsonKey(name: 'FORM_STATUS')
  final String formStatus;

  @JsonKey(name: 'CRF_DATE')
  final String? crfDate;

  @JsonKey(name: 'NR_YN')
  final String nrYn;

  @JsonKey(name: 'FORM_DATA_SEQ')
  final int formDataSeq;

  @JsonKey(name: 'STUDYEVENT_DATA_SEQ')
  final int studyEventDataSeq;

  @JsonKey(name: 'MANDATORY')
  final String mandatory;

  @JsonKey(name: 'FORM_CNT')
  final int formCnt;

  ScheduleItem({
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
    this.formRepeatKey,
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
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleItemToJson(this);
}

extension EproScheduleResMapper on EproScheduleRes {
  EproScheduleModel toModel() => EproScheduleModel(
        scheduleList: scheduleList.map((e) => e.toModel()).toList(),
        resultValue: resultValue,
      );
}

extension ScheduleItemMapper on ScheduleItem {
  ScheduleItemModel toModel() => ScheduleItemModel(
        studyEventSeq: studyEventSeq,
        studyEventName: studyEventName,
        eventStatus: eventStatus,
        isNew: isNew,
        studyEventRepeatKey: studyEventRepeatKey,
        visitSeq: visitSeq,
        formSeq: formSeq,
        formName: formName,
        noForm: noForm,
        formVersionSeq: formVersionSeq,
        fvStatus: fvStatus,
        formRepeating: formRepeating,
        formRepeatKey: formRepeatKey ?? 0,
        feSeq: feSeq,
        visitOrder: visitOrder,
        eventCycle: eventCycle,
        eventInterval: eventInterval,
        eventType: eventType,
        prevStudyEventOid: prevStudyEventOid,
        scheduleYn: scheduleYn,
        plannedDate: plannedDate ?? DateTime.now(),
        minPlannedDate: minPlannedDate,
        maxPlannedDate: maxPlannedDate,
        visitDate: visitDate,
        pastYn: _boolToString(pastYn),
        visitYn: visitYn,
        formStatus: formStatus,
        crfDate: crfDate,
        nrYn: nrYn,
        formDataSeq: formDataSeq,
        studyEventDataSeq: studyEventDataSeq,
        mandatory: mandatory,
        formCnt: formCnt,
      );
}

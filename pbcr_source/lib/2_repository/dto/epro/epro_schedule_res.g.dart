// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epro_schedule_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EproScheduleRes _$EproScheduleResFromJson(Map<String, dynamic> json) =>
    EproScheduleRes(
      scheduleList: (json['scheduleList'] as List<dynamic>)
          .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      resultValue: json['_RSLT_VAL'] as String,
    );

Map<String, dynamic> _$EproScheduleResToJson(EproScheduleRes instance) =>
    <String, dynamic>{
      'scheduleList': instance.scheduleList,
      '_RSLT_VAL': instance.resultValue,
    };

ScheduleItem _$ScheduleItemFromJson(Map<String, dynamic> json) => ScheduleItem(
      studyEventSeq: (json['STUDYEVENT_SEQ'] as num).toInt(),
      studyEventName: json['STUDYEVENT_NAME'] as String,
      eventStatus: json['EVENT_STATUS'] as String,
      isNew: json['IS_NEW'] as String,
      studyEventRepeatKey: (json['STUDYEVENT_REPEATKEY'] as num).toInt(),
      visitSeq: (json['VISIT_SEQ'] as num).toInt(),
      formSeq: (json['FORM_SEQ'] as num).toInt(),
      formName: json['FORM_NAME'] as String,
      noForm: json['NO_FORM'] as String,
      formVersionSeq: (json['FORM_VERSION_SEQ'] as num).toInt(),
      fvStatus: json['FV_STATUS'] as String,
      formRepeating: json['FORM_REPEATING'] as String,
      formRepeatKey: (json['FORM_REPEATKEY'] as num?)?.toInt(),
      feSeq: (json['FE_SEQ'] as num).toInt(),
      visitOrder: (json['VISIT_ORDER'] as num).toInt(),
      eventCycle: json['EVENT_CYCLE'] as String,
      eventInterval: json['EVENT_INTERVAL'] as String,
      eventType: json['EVENT_TYPE'] as String,
      prevStudyEventOid: (json['PREV_STUDYEVENT_OID'] as num).toInt(),
      scheduleYn: json['SCHEDULE_YN'] as String,
      plannedDate: _stringToDateTime(json['PLANNED_DATE'] as String),
      minPlannedDate: _stringToDateTime(json['MIN_PLANNED_DATE'] as String),
      maxPlannedDate: _stringToDateTime(json['MAX_PLANNED_DATE'] as String),
      visitDate: json['VISIT_DATE'] as String?,
      pastYn: _stringToBool(json['PAST_YN'] as String),
      visitYn: json['VISIT_YN'] as String,
      formStatus: json['FORM_STATUS'] as String,
      crfDate: json['CRF_DATE'] as String?,
      nrYn: json['NR_YN'] as String,
      formDataSeq: (json['FORM_DATA_SEQ'] as num).toInt(),
      studyEventDataSeq: (json['STUDYEVENT_DATA_SEQ'] as num).toInt(),
      mandatory: json['MANDATORY'] as String,
      formCnt: (json['FORM_CNT'] as num).toInt(),
    );

Map<String, dynamic> _$ScheduleItemToJson(ScheduleItem instance) =>
    <String, dynamic>{
      'STUDYEVENT_SEQ': instance.studyEventSeq,
      'STUDYEVENT_NAME': instance.studyEventName,
      'EVENT_STATUS': instance.eventStatus,
      'IS_NEW': instance.isNew,
      'STUDYEVENT_REPEATKEY': instance.studyEventRepeatKey,
      'VISIT_SEQ': instance.visitSeq,
      'FORM_SEQ': instance.formSeq,
      'FORM_NAME': instance.formName,
      'NO_FORM': instance.noForm,
      'FORM_VERSION_SEQ': instance.formVersionSeq,
      'FV_STATUS': instance.fvStatus,
      'FORM_REPEATING': instance.formRepeating,
      'FORM_REPEATKEY': instance.formRepeatKey,
      'FE_SEQ': instance.feSeq,
      'VISIT_ORDER': instance.visitOrder,
      'EVENT_CYCLE': instance.eventCycle,
      'EVENT_INTERVAL': instance.eventInterval,
      'EVENT_TYPE': instance.eventType,
      'PREV_STUDYEVENT_OID': instance.prevStudyEventOid,
      'SCHEDULE_YN': instance.scheduleYn,
      'PLANNED_DATE': _dateTimeToString(instance.plannedDate),
      'MIN_PLANNED_DATE': _dateTimeToString(instance.minPlannedDate),
      'MAX_PLANNED_DATE': _dateTimeToString(instance.maxPlannedDate),
      'VISIT_DATE': instance.visitDate,
      'PAST_YN': _boolToString(instance.pastYn),
      'VISIT_YN': instance.visitYn,
      'FORM_STATUS': instance.formStatus,
      'CRF_DATE': instance.crfDate,
      'NR_YN': instance.nrYn,
      'FORM_DATA_SEQ': instance.formDataSeq,
      'STUDYEVENT_DATA_SEQ': instance.studyEventDataSeq,
      'MANDATORY': instance.mandatory,
      'FORM_CNT': instance.formCnt,
    };

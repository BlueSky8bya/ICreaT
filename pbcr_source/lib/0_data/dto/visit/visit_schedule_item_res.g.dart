// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_schedule_item_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitScheduleItemRes _$VisitScheduleItemResFromJson(
        Map<String, dynamic> json) =>
    VisitScheduleItemRes(
      studyEventSeq: (json['STUDYEVENT_SEQ'] as num).toInt(),
      studyEventName: json['STUDYEVENT_NAME'] as String,
      formSeq: (json['FORM_SEQ'] as num).toInt(),
      formVersionSeq: (json['FORM_VERSION_SEQ'] as num?)?.toInt(),
      formName: json['FORM_NAME'] as String,
      plannedDate: json['PLANNED_DATE'] as String?,
      visitDate: json['VISIT_DATE'] as String?,
      visitYn: json['VISIT_YN'] as String,
      formStatus: json['FORM_STATUS'] as String,
      formDataSeq: (json['FORM_DATA_SEQ'] as num).toInt(),
      studyEventDataSeq: (json['STUDYEVENT_DATA_SEQ'] as num).toInt(),
      mandatory: json['MANDATORY'] as String,
    );

Map<String, dynamic> _$VisitScheduleItemResToJson(
        VisitScheduleItemRes instance) =>
    <String, dynamic>{
      'STUDYEVENT_SEQ': instance.studyEventSeq,
      'STUDYEVENT_NAME': instance.studyEventName,
      'PLANNED_DATE': instance.plannedDate,
      'VISIT_DATE': instance.visitDate,
      'FORM_SEQ': instance.formSeq,
      'FORM_VERSION_SEQ': instance.formVersionSeq,
      'FORM_NAME': instance.formName,
      'FORM_STATUS': instance.formStatus,
      'FORM_DATA_SEQ': instance.formDataSeq,
      'STUDYEVENT_DATA_SEQ': instance.studyEventDataSeq,
      'MANDATORY': instance.mandatory,
      'VISIT_YN': instance.visitYn,
    };

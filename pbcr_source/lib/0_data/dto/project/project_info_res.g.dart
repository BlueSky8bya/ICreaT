// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectInfoRes _$ProjectInfoResFromJson(Map<String, dynamic> json) =>
    ProjectInfoRes(
      resultValue: json['_RSLT_VAL'] as String,
      studyNo: json['study_no'] as String,
      studyName: json['study_name'] as String,
      studyFullName: json['study_fullname'] as String,
      organCode: json['organ_cd'] as String,
      status: json['status'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      icfDocument: json['icf_document'] as String?,
    );

Map<String, dynamic> _$ProjectInfoResToJson(ProjectInfoRes instance) =>
    <String, dynamic>{
      '_RSLT_VAL': instance.resultValue,
      'study_no': instance.studyNo,
      'study_name': instance.studyName,
      'study_fullname': instance.studyFullName,
      'organ_cd': instance.organCode,
      'status': instance.status,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'icf_document': instance.icfDocument,
    };

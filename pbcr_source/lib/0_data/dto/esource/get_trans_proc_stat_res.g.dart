// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_trans_proc_stat_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTransProcStatRes _$GetTransProcStatResFromJson(Map<String, dynamic> json) =>
    GetTransProcStatRes(
      serviceUUID: json['serviceUUID'] as String,
      studyOid: json['study_oid'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => TransProcStatData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetTransProcStatResToJson(
        GetTransProcStatRes instance) =>
    <String, dynamic>{
      'serviceUUID': instance.serviceUUID,
      'study_oid': instance.studyOid,
      'data': instance.data,
    };

TransProcStatData _$TransProcStatDataFromJson(Map<String, dynamic> json) =>
    TransProcStatData(
      personId: json['person_id'] as String,
      visitOccurrenceId: json['visit_occurrence_id'] as String,
      formName: json['form_name'] as String,
      procStatCd: json['proc_stat_cd'] as String,
      procStatName: json['proc_stat_name'] as String,
    );

Map<String, dynamic> _$TransProcStatDataToJson(TransProcStatData instance) =>
    <String, dynamic>{
      'person_id': instance.personId,
      'visit_occurrence_id': instance.visitOccurrenceId,
      'form_name': instance.formName,
      'proc_stat_cd': instance.procStatCd,
      'proc_stat_name': instance.procStatName,
    };

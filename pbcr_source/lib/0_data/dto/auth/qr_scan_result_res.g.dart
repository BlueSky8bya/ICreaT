// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_scan_result_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrScanResultRes _$QrScanResultResFromJson(Map<String, dynamic> json) =>
    QrScanResultRes(
      studyNo: json['stdy_no'] as String,
      subjectId: json['subject_id'] as String,
      organCd: json['organ_cd'] as String,
      patName: json['pat_name'] as String,
    );

Map<String, dynamic> _$QrScanResultResToJson(QrScanResultRes instance) =>
    <String, dynamic>{
      'stdy_no': instance.studyNo,
      'subject_id': instance.subjectId,
      'organ_cd': instance.organCd,
      'pat_name': instance.patName,
    };

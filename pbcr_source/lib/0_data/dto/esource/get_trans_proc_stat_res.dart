import 'package:json_annotation/json_annotation.dart';

part 'get_trans_proc_stat_res.g.dart';

@JsonSerializable()
class GetTransProcStatRes {
  @JsonKey(name: 'serviceUUID')
  final String serviceUUID;
  @JsonKey(name: 'study_oid')
  final String studyOid;
  @JsonKey(name: 'data')
  final List<TransProcStatData> data;

  const GetTransProcStatRes({
    required this.serviceUUID,
    required this.studyOid,
    required this.data,
  });

  factory GetTransProcStatRes.fromJson(Map<String, dynamic> json) =>
      _$GetTransProcStatResFromJson(json);
  Map<String, dynamic> toJson() => _$GetTransProcStatResToJson(this);
}

@JsonSerializable()
class TransProcStatData {
  @JsonKey(name: 'person_id')
  final String personId;
  @JsonKey(name: 'visit_occurrence_id')
  final String visitOccurrenceId;
  @JsonKey(name: 'form_name')
  final String formName;
  @JsonKey(name: 'proc_stat_cd')
  final String procStatCd;
  @JsonKey(name: 'proc_stat_name')
  final String procStatName;

  const TransProcStatData({
    required this.personId,
    required this.visitOccurrenceId,
    required this.formName,
    required this.procStatCd,
    required this.procStatName,
  });

  factory TransProcStatData.fromJson(Map<String, dynamic> json) =>
      _$TransProcStatDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransProcStatDataToJson(this);
} 
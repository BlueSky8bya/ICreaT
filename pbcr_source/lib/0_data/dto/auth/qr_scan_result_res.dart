import 'package:json_annotation/json_annotation.dart';

part 'qr_scan_result_res.g.dart';

@JsonSerializable()
class QrScanResultRes {
  @JsonKey(name: 'stdy_no')
  final String studyNo;

  @JsonKey(name: 'subject_id')
  final String subjectId;

  @JsonKey(name: 'organ_cd')
  final String organCd;

  @JsonKey(name: 'pat_name')
  final String patName;

  QrScanResultRes({
    required this.studyNo,
    required this.subjectId,
    required this.organCd,
    required this.patName,
  });

  factory QrScanResultRes.fromJson(Map<String, dynamic> json) =>
      _$QrScanResultResFromJson(json);

  Map<String, dynamic> toJson() => _$QrScanResultResToJson(this);
}

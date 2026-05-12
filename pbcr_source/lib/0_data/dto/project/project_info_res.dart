import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/project_info.dart';

part 'project_info_res.g.dart';

@JsonSerializable()
class ProjectInfoRes {
  @JsonKey(name: '_RSLT_VAL')
  final String resultValue;
  @JsonKey(name: 'study_no')
  final String studyNo;
  @JsonKey(name: 'study_name')
  final String studyName;
  @JsonKey(name: 'study_fullname')
  final String studyFullName;
  @JsonKey(name: 'organ_cd')
  final String organCode;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  @JsonKey(name: 'icf_document')
  final String? icfDocument;

  ProjectInfoRes({
    required this.resultValue,
    required this.studyNo,
    required this.studyName,
    required this.studyFullName,
    required this.organCode,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.icfDocument
  });

  factory ProjectInfoRes.fromJson(Map<String, dynamic> json) =>
      _$ProjectInfoResFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectInfoResToJson(this);
}

extension ProjectInfoResExt on ProjectInfoRes {
  ProjectInfoModel toModel() => ProjectInfoModel(
        studyNo: studyNo,
        studyName: studyName,
        studyFullName: studyFullName,
        organCode: organCode,
        status: status,
        startDate: startDate,
        endDate: endDate,
        icfDocument: icfDocument ?? '',
      );
}

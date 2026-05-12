import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/icreat/visit_schedule_item_model.dart';

part 'visit_schedule_item_res.g.dart';

@JsonSerializable()
class VisitScheduleItemRes {
  @JsonKey(name: 'STUDYEVENT_SEQ')
  final int studyEventSeq;

  @JsonKey(name: 'STUDYEVENT_NAME')
  final String studyEventName;

  @JsonKey(name: 'PLANNED_DATE')
  final String? plannedDate;

  @JsonKey(name: 'VISIT_DATE')
  final String? visitDate;

  @JsonKey(name: 'FORM_SEQ')
  final int formSeq;

  @JsonKey(name: 'FORM_VERSION_SEQ')
  final int? formVersionSeq;

  @JsonKey(name: 'FORM_NAME')
  final String formName;

  @JsonKey(name: 'FORM_STATUS')
  final String formStatus;

  @JsonKey(name: 'FORM_DATA_SEQ')
  final int formDataSeq;

  @JsonKey(name: 'STUDYEVENT_DATA_SEQ')
  final int studyEventDataSeq;

  @JsonKey(name: 'MANDATORY')
  final String mandatory;

  @JsonKey(name: 'VISIT_YN')
  final String visitYn;

  VisitScheduleItemRes({
    required this.studyEventSeq,
    required this.studyEventName,
    required this.formSeq,
    required this.formVersionSeq,
    required this.formName,
    this.plannedDate,
    required this.visitDate,
    required this.visitYn,
    required this.formStatus,
    required this.formDataSeq,
    required this.studyEventDataSeq,
    required this.mandatory,
  });

  factory VisitScheduleItemRes.fromJson(Map<String, dynamic> json) =>
      _$VisitScheduleItemResFromJson(json);

  Map<String, dynamic> toJson() => _$VisitScheduleItemResToJson(this);
}

extension VisitScheduleItemResExt on VisitScheduleItemRes {
  VisitScheduleItemModel toModel() => VisitScheduleItemModel(
        studyEventSeq: studyEventSeq,
        studyEventName: studyEventName,
        formSeq: formSeq,
        formVersionSeq: formVersionSeq ?? 0,
        formName: formName,
        plannedDate: plannedDate ?? '',
        visitDate: visitDate ?? '',
        visitYn: visitYn,
        formStatus: _convertFormStatus(formStatus),
        formDataSeq: formDataSeq,
        studyEventDataSeq: studyEventDataSeq,
        mandatory: mandatory,
      );

  String _convertFormStatus(String status) {
    switch (status) {
      case 'R':
        return 'Ready';
      case 'Y':
        return 'Completed';
      case 'N':
        return 'Write';
      case 'C':
        return 'Confirm';
      default:
        return status;
    }
  }
}

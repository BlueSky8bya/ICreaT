class VisitScheduleItemModel {
  final int studyEventSeq;
  final String studyEventName;
  final String? plannedDate;
  final String? visitDate;
  final int formSeq;
  final int formVersionSeq;
  final String formName;
  final String formStatus;
  final int formDataSeq;
  final int studyEventDataSeq;
  final String mandatory;
  final String visitYn;

  VisitScheduleItemModel({
    required this.studyEventSeq,
    required this.studyEventName,
    required this.formSeq,
    required this.formVersionSeq,
    required this.formName,
    required this.plannedDate,
    required this.visitDate,
    required this.visitYn,
    required this.formStatus,
    required this.formDataSeq,
    required this.studyEventDataSeq,
    required this.mandatory,
  });

  DateTime? get plannedDateTime {
    if (plannedDate == null) {
      return null;
    }
    final ymd = plannedDate!.split('-');
    if (ymd.length != 3) {
      return null;
    }
    return DateTime(
      int.parse(ymd[0]),
      int.parse(ymd[1]),
      int.parse(ymd[2]),
    );
  }
}

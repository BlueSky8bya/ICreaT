class ProjectInfoModel {
  final String studyNo;
  final String studyName;
  final String studyFullName;
  final String organCode;
  final String status;
  final String startDate;
  final String endDate;
  final String icfDocument;

  ProjectInfoModel({
    required this.studyNo,
    required this.studyName,
    required this.studyFullName,
    required this.organCode,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.icfDocument,
  });

  DateTime get startDateTime {
    return DateTime.parse(startDate);
  }

  DateTime get endDateTime {
    return DateTime.parse(endDate);
  }

  @override
  String toString() {
    return 'ProjectInfoModel(studyNo: $studyNo, studyName: $studyName, studyFullName: $studyFullName, organCode: $organCode, status: $status, startDate: $startDate, endDate: $endDate)';
  }
}

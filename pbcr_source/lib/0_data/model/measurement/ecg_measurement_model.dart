class EcgMeasurementModel {
  final String userName;
  final int menuAuthLevel;
  final String userOrganName;
  final String resultValue;
  final String userId;
  final List<EcgMeasurementItemModel> measurements;

  EcgMeasurementModel({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });
}

class EcgMeasurementItemModel {
  final int uk;
  final String studyNo;
  final int pid;
  final String organCd;
  final String isScheduled;
  final String isManual;
  final String ecgDiagnosis;
  final int ecgVentRate;
  final int ecgPDuration;
  final int ecgPrInterval;
  final int ecgQrsDuration;
  final int ecgQtInterval;
  final int ecgQtcInterval;
  final String ecgNode;
  final String ecgRhythm;
  final String ecgConclusion;
  final String? ecgMemo;

  EcgMeasurementItemModel({
    required this.uk,
    required this.studyNo,
    required this.pid,
    required this.organCd,
    required this.isScheduled,
    required this.isManual,
    required this.ecgDiagnosis,
    required this.ecgVentRate,
    required this.ecgPDuration,
    required this.ecgPrInterval,
    required this.ecgQrsDuration,
    required this.ecgQtInterval,
    required this.ecgQtcInterval,
    required this.ecgNode,
    required this.ecgRhythm,
    required this.ecgConclusion,
    this.ecgMemo,
  });
}

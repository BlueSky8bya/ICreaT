class BpMeasurementModel {
  final String userName;
  final int menuAuthLevel;
  final String userOrganName;
  final String resultValue;
  final String userId;
  final List<BpMeasurementItemModel> measurements;

  BpMeasurementModel({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });
}

class BpMeasurementItemModel {
  final int uk;
  final String studyNo;
  final int pid;
  final String organCd;
  final String isScheduled;
  final String isManual;
  final int bpSystolic;
  final int bpDiastolic;
  final int? bpPulse;
  final String? bpMemo;

  BpMeasurementItemModel({
    required this.uk,
    required this.studyNo,
    required this.pid,
    required this.organCd,
    required this.isScheduled,
    required this.isManual,
    required this.bpSystolic,
    required this.bpDiastolic,
    this.bpPulse,
    this.bpMemo,
  });
}

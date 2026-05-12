class StepMeasurementModel {
  final String userName;
  final int menuAuthLevel;
  final String userOrganName;
  final String resultValue;
  final String userId;
  final List<StepMeasurementItemModel> measurements;

  StepMeasurementModel({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });
}

class StepMeasurementItemModel {
  final int uk;
  final String studyNo;
  final int pid;
  final String organCd;
  final String isScheduled;
  final String isManual;
  final int stepTotal;
  final double stepDistance;
  final double stepCalories;
  final String? stepMemo;

  StepMeasurementItemModel({
    required this.uk,
    required this.studyNo,
    required this.pid,
    required this.organCd,
    required this.isScheduled,
    required this.isManual,
    required this.stepTotal,
    required this.stepDistance,
    required this.stepCalories,
    this.stepMemo,
  });
}

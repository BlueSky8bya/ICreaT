class SleepMeasurementModel {
  final String userName;
  final int menuAuthLevel;
  final String userOrganName;
  final String resultValue;
  final String userId;
  final List<SleepMeasurementItemModel> measurements;

  SleepMeasurementModel({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });
}

class SleepMeasurementItemModel {
  final int uk;
  final String studyNo;
  final int pid;
  final String organCd;
  final String isScheduled;
  final String isManual;
  final int sleepTotalMinutes;
  final int sleepDeepMinutes;
  final int sleepLightMinutes;
  final int sleepWakeCount;
  final String? sleepMemo;

  SleepMeasurementItemModel({
    required this.uk,
    required this.studyNo,
    required this.pid,
    required this.organCd,
    required this.isScheduled,
    required this.isManual,
    required this.sleepTotalMinutes,
    required this.sleepDeepMinutes,
    required this.sleepLightMinutes,
    required this.sleepWakeCount,
    this.sleepMemo,
  });
}

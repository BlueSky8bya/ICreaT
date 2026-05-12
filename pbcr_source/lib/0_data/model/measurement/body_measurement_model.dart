class BodyMeasurementModel {
  final String userName;
  final int menuAuthLevel;
  final String userOrganName;
  final String resultValue;
  final String userId;
  final List<BodyMeasurementItemModel> measurements;

  BodyMeasurementModel({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });
}

class BodyMeasurementItemModel {
  final int uk;
  final String studyNo;
  final int pid;
  final String organCd;
  final String isScheduled;
  final String isManual;
  final double bodyWeight;
  final double? bodyBmi;
  final double? bodyFatPercentage;
  final double? bodyBasalMetabolism;
  final double? bodySkeletalMusclePercentage;
  final double? bodyVisceralFatLevel;
  final int? bodyAge;
  final String? bodyMemo;

  BodyMeasurementItemModel({
    required this.uk,
    required this.studyNo,
    required this.pid,
    required this.organCd,
    required this.isScheduled,
    required this.isManual,
    required this.bodyWeight,
    this.bodyBmi,
    this.bodyFatPercentage,
    this.bodyBasalMetabolism,
    this.bodySkeletalMusclePercentage,
    this.bodyVisceralFatLevel,
    this.bodyAge,
    this.bodyMemo,
  });
}

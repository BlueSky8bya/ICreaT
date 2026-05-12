class BloodPressureModel {
  final int systole;
  final int diastole;
  final int pulse;

  final DateTime recordedAt;

  const BloodPressureModel({
    required this.systole,
    required this.diastole,
    required this.pulse,
    required this.recordedAt,
  });
}

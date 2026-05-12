import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/measurement/body_measurement_model.dart';

part 'body_measurement_res.g.dart';

@JsonSerializable()
class BodyMeasurementRes {
  @JsonKey(name: 'usernm')
  final String userName;

  @JsonKey(name: '_MENU_AUTH_LVL')
  final int menuAuthLevel;

  @JsonKey(name: 'userorgannm')
  final String userOrganName;

  @JsonKey(name: '_RSLT_VAL')
  final String resultValue;

  @JsonKey(name: 'userid')
  final String userId;

  @JsonKey(name: 'measurements')
  final List<BodyMeasurementItemRes> measurements;

  BodyMeasurementRes({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });

  factory BodyMeasurementRes.fromJson(Map<String, dynamic> json) =>
      _$BodyMeasurementResFromJson(json);

  Map<String, dynamic> toJson() => _$BodyMeasurementResToJson(this);

  BodyMeasurementModel toModel() => BodyMeasurementModel(
        userName: userName,
        menuAuthLevel: menuAuthLevel,
        userOrganName: userOrganName,
        resultValue: resultValue,
        userId: userId,
        measurements: measurements.map((e) => e.toModel()).toList(),
      );
}

@JsonSerializable()
class BodyMeasurementItemRes {
  @JsonKey(name: 'UK')
  final int uk;

  @JsonKey(name: 'STDYNO')
  final String studyNo;

  @JsonKey(name: 'PID')
  final int pid;

  @JsonKey(name: 'ORGANCD')
  final String organCd;

  @JsonKey(name: 'IS_SCHEDULED')
  final String isScheduled;

  @JsonKey(name: 'IS_MANUAL')
  final String isManual;

  @JsonKey(name: 'BODY_WEIGHT')
  final double bodyWeight;

  @JsonKey(name: 'BODY_BMI')
  final double? bodyBmi;

  @JsonKey(name: 'BODY_FAT_PERCENTAGE')
  final double? bodyFatPercentage;

  @JsonKey(name: 'BODY_BASAL_METABOLISM')
  final double? bodyBasalMetabolism;

  @JsonKey(name: 'BODY_SKELETAL_MUSCLE_PERCENTAGE')
  final double? bodySkeletalMusclePercentage;

  @JsonKey(name: 'BODY_VISCERAL_FAT_LEVEL')
  final double? bodyVisceralFatLevel;

  @JsonKey(name: 'BODY_AGE')
  final int? bodyAge;

  @JsonKey(name: 'BODY_MEMO')
  final String? bodyMemo;

  BodyMeasurementItemRes({
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

  factory BodyMeasurementItemRes.fromJson(Map<String, dynamic> json) =>
      _$BodyMeasurementItemResFromJson(json);

  Map<String, dynamic> toJson() => _$BodyMeasurementItemResToJson(this);

  BodyMeasurementItemModel toModel() => BodyMeasurementItemModel(
        uk: uk,
        studyNo: studyNo,
        pid: pid,
        organCd: organCd,
        isScheduled: isScheduled,
        isManual: isManual,
        bodyWeight: bodyWeight,
        bodyBmi: bodyBmi,
        bodyFatPercentage: bodyFatPercentage,
        bodyBasalMetabolism: bodyBasalMetabolism,
        bodySkeletalMusclePercentage: bodySkeletalMusclePercentage,
        bodyVisceralFatLevel: bodyVisceralFatLevel,
        bodyAge: bodyAge,
        bodyMemo: bodyMemo,
      );
}

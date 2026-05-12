import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/measurement/step_measurement_model.dart';

part 'step_measurement_res.g.dart';

@JsonSerializable()
class StepMeasurementRes {
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
  final List<StepMeasurementItemRes> measurements;

  StepMeasurementRes({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });

  factory StepMeasurementRes.fromJson(Map<String, dynamic> json) =>
      _$StepMeasurementResFromJson(json);

  Map<String, dynamic> toJson() => _$StepMeasurementResToJson(this);
}

@JsonSerializable()
class StepMeasurementItemRes {
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

  @JsonKey(name: 'STEP_TOTAL')
  final int stepTotal;

  @JsonKey(name: 'STEP_DISTANCE')
  final double stepDistance;

  @JsonKey(name: 'STEP_CALORIES')
  final double stepCalories;

  @JsonKey(name: 'STEP_MEMO')
  final String? stepMemo;

  StepMeasurementItemRes({
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

  factory StepMeasurementItemRes.fromJson(Map<String, dynamic> json) =>
      _$StepMeasurementItemResFromJson(json);

  Map<String, dynamic> toJson() => _$StepMeasurementItemResToJson(this);
}

extension StepMeasurementResMapper on StepMeasurementRes {
  StepMeasurementModel toModel() => StepMeasurementModel(
        userName: userName,
        menuAuthLevel: menuAuthLevel,
        userOrganName: userOrganName,
        resultValue: resultValue,
        userId: userId,
        measurements: measurements.map((e) => e.toModel()).toList(),
      );
}

extension StepMeasurementItemResMapper on StepMeasurementItemRes {
  StepMeasurementItemModel toModel() => StepMeasurementItemModel(
        uk: uk,
        studyNo: studyNo,
        pid: pid,
        organCd: organCd,
        isScheduled: isScheduled,
        isManual: isManual,
        stepTotal: stepTotal,
        stepDistance: stepDistance,
        stepCalories: stepCalories,
        stepMemo: stepMemo,
      );
}

import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/measurement/bp_measurement_model.dart';

part 'bp_measurement_res.g.dart';

@JsonSerializable()
class BpMeasurementRes {
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
  final List<BpMeasurementItemRes> measurements;

  BpMeasurementRes({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });

  factory BpMeasurementRes.fromJson(Map<String, dynamic> json) =>
      _$BpMeasurementResFromJson(json);

  Map<String, dynamic> toJson() => _$BpMeasurementResToJson(this);

  BpMeasurementModel toModel() => BpMeasurementModel(
        userName: userName,
        menuAuthLevel: menuAuthLevel,
        userOrganName: userOrganName,
        resultValue: resultValue,
        userId: userId,
        measurements: measurements.map((e) => e.toModel()).toList(),
      );
}

@JsonSerializable()
class BpMeasurementItemRes {
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

  @JsonKey(name: 'BP_SYSTOLIC')
  final int bpSystolic;

  @JsonKey(name: 'BP_DIASTOLIC')
  final int bpDiastolic;

  @JsonKey(name: 'BP_PULSE')
  final int? bpPulse;

  @JsonKey(name: 'BP_MEMO')
  final String? bpMemo;

  BpMeasurementItemRes({
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

  factory BpMeasurementItemRes.fromJson(Map<String, dynamic> json) =>
      _$BpMeasurementItemResFromJson(json);

  Map<String, dynamic> toJson() => _$BpMeasurementItemResToJson(this);

  BpMeasurementItemModel toModel() => BpMeasurementItemModel(
        uk: uk,
        studyNo: studyNo,
        pid: pid,
        organCd: organCd,
        isScheduled: isScheduled,
        isManual: isManual,
        bpSystolic: bpSystolic,
        bpDiastolic: bpDiastolic,
        bpPulse: bpPulse,
        bpMemo: bpMemo,
      );
}

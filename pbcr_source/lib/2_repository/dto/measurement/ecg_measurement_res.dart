import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/measurement/ecg_measurement_model.dart';

part 'ecg_measurement_res.g.dart';

@JsonSerializable()
class EcgMeasurementRes {
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
  final List<EcgMeasurementItemRes> measurements;

  EcgMeasurementRes({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.resultValue,
    required this.userId,
    required this.measurements,
  });

  factory EcgMeasurementRes.fromJson(Map<String, dynamic> json) =>
      _$EcgMeasurementResFromJson(json);

  Map<String, dynamic> toJson() => _$EcgMeasurementResToJson(this);

  EcgMeasurementModel toModel() => EcgMeasurementModel(
        userName: userName,
        menuAuthLevel: menuAuthLevel,
        userOrganName: userOrganName,
        resultValue: resultValue,
        userId: userId,
        measurements: measurements.map((e) => e.toModel()).toList(),
      );
}

@JsonSerializable()
class EcgMeasurementItemRes {
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

  @JsonKey(name: 'ECG_DIAGNOSIS')
  final String ecgDiagnosis;

  @JsonKey(name: 'ECG_VENT_RATE')
  final int ecgVentRate;

  @JsonKey(name: 'ECG_P_DURATION')
  final int ecgPDuration;

  @JsonKey(name: 'ECG_PR_INTERVAL')
  final int ecgPrInterval;

  @JsonKey(name: 'ECG_QRS_DURATION')
  final int ecgQrsDuration;

  @JsonKey(name: 'ECG_QT_INTERVAL')
  final int ecgQtInterval;

  @JsonKey(name: 'ECG_QTC_INTERVAL')
  final int ecgQtcInterval;

  @JsonKey(name: 'ECG_NODE')
  final String ecgNode;

  @JsonKey(name: 'ECG_RHYTHM')
  final String ecgRhythm;

  @JsonKey(name: 'ECG_CONCLUSION')
  final String ecgConclusion;

  @JsonKey(name: 'ECG_MEMO')
  final String? ecgMemo;

  EcgMeasurementItemRes({
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

  factory EcgMeasurementItemRes.fromJson(Map<String, dynamic> json) =>
      _$EcgMeasurementItemResFromJson(json);

  Map<String, dynamic> toJson() => _$EcgMeasurementItemResToJson(this);

  EcgMeasurementItemModel toModel() => EcgMeasurementItemModel(
        uk: uk,
        studyNo: studyNo,
        pid: pid,
        organCd: organCd,
        isScheduled: isScheduled,
        isManual: isManual,
        ecgDiagnosis: ecgDiagnosis,
        ecgVentRate: ecgVentRate,
        ecgPDuration: ecgPDuration,
        ecgPrInterval: ecgPrInterval,
        ecgQrsDuration: ecgQrsDuration,
        ecgQtInterval: ecgQtInterval,
        ecgQtcInterval: ecgQtcInterval,
        ecgNode: ecgNode,
        ecgRhythm: ecgRhythm,
        ecgConclusion: ecgConclusion,
        ecgMemo: ecgMemo,
      );
}

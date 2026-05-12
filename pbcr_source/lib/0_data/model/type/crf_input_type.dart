import 'package:json_annotation/json_annotation.dart';

enum CrfInputType {
  @JsonValue("TextBox")
  textBox,
  @JsonValue("Date")
  date,
  @JsonValue("Time")
  time,
  @JsonValue("Calculate")
  calculate,
  @JsonValue("Comments")
  comments,
  @JsonValue("Radio")
  radio,
  @JsonValue("DropDown")
  dropDown,
  @JsonValue("CheckBox")
  checkBox,
  @JsonValue("AE")
  ae,
  @JsonValue("Drug")
  drug,
  @JsonValue("ICD10")
  icd10,
  @JsonValue("M_BP_SYS")
  measurementBpSys,
  @JsonValue("M_BP_DIA")
  measurementBpDia,
  @JsonValue("M_BP_PULSE")
  measurementBpPulse,
  @JsonValue("M_BT")
  measurementBodyTemperature,
  @JsonValue("M_BW")
  measurementBodyWeight,
  @JsonValue("M_SLEEP_START")
  measurementSleepStart,
  @JsonValue("M_SLEEP_END")
  measurementSleepEnd,
  @JsonValue("M_SLEEP_DURATION")
  measurementSleepDuration,
  @JsonValue("M_STEP")
  measurementStep,
  unknown;

  int? get maxLength {
    switch (this) {
      case CrfInputType.comments:
        return 1000;
      case CrfInputType.textBox:
        return 100;
      default:
        return null;
    }
  }

  /// CRF 입력 정보가 코드 타입인지 여부
  /// 코드 타입인 경우 itemCode의 key와 value를 각각  currValue(key)와 currLabel(valye)로 전달해야한다.
  bool get isCodeInputType {
    return this == CrfInputType.checkBox ||
        this == CrfInputType.radio ||
        this == CrfInputType.dropDown;
  }

  /// 측정 타입인지 여부
  bool get isMeasurementInputType {
    return this == CrfInputType.measurementBpSys ||
        this == CrfInputType.measurementBpDia ||
        this == CrfInputType.measurementBpPulse ||
        this == CrfInputType.measurementBodyTemperature ||
        this == CrfInputType.measurementBodyWeight ||
        this == CrfInputType.measurementSleepStart ||
        this == CrfInputType.measurementSleepEnd ||
        this == CrfInputType.measurementSleepDuration ||
        this == CrfInputType.measurementStep;
  }
}

extension CrfInputTypeExtension on String {
  CrfInputType toCrfInputType() {
    return CrfInputType.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == toLowerCase(),
      orElse: () => CrfInputType.unknown,
    );
  }
}

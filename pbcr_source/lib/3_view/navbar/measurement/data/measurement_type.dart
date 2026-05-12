import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';

enum MeasurementType {
  bloodPressure,
  bodyWeight,
  temperature,
  sleep,
  step,
}

extension MeasurementTypeExt on MeasurementType {
  String get label {
    switch (this) {
      case MeasurementType.bloodPressure:
        return '혈압';
      case MeasurementType.bodyWeight:
        return '몸무게';
      case MeasurementType.temperature:
        return '체온';
      case MeasurementType.sleep:
        return '수면';
      case MeasurementType.step:
        return '걸음수';
    }
  }

  String get deviceName {
    switch (this) {
      case MeasurementType.bloodPressure:
        return '혈압계';
      case MeasurementType.bodyWeight:
        return '체중계';
      case MeasurementType.temperature:
        return '체온계';
      case MeasurementType.sleep:
        return '수면계';
      case MeasurementType.step:
        return '걸음수계';
    }
  }

  SvgIcons get svgIcon {
    switch (this) {
      case MeasurementType.bloodPressure:
        return SvgIcons.bloodPressure;
      case MeasurementType.bodyWeight:
        return SvgIcons.weight;
      case MeasurementType.temperature:
        return SvgIcons.thermometer;
      case MeasurementType.sleep:
        return SvgIcons.thermometer;
      case MeasurementType.step:
        return SvgIcons.thermometer;
    }
  }
}

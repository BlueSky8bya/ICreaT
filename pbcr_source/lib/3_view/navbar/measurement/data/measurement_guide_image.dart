enum MeasurementGuideImage {
  measureBp1,
  measureBp2,
  measureBp3,

  connectBp1,
  connectBp2,
  connectBp3,

  manualBp1,
  manualBp2,

  measureWeight1,
  measureWeight2,
  measureWeight3,

  connectWeight1,
  connectWeight2,

  connectTeperature1,
  connectTeperature2,

  measureTemperature1,
  measureTemperature2;

  String get path {
    switch (this) {
      case MeasurementGuideImage.measureBp1:
        return 'assets/images/measurement/guide/blood_pressure_measure_1.png';
      case MeasurementGuideImage.measureBp2:
        return 'assets/images/measurement/guide/blood_pressure_measure_2.png';
      case MeasurementGuideImage.measureBp3:
        return 'assets/images/measurement/guide/blood_pressure_measure_3.png';
      case MeasurementGuideImage.connectBp1:
        return 'assets/images/measurement/guide/blood_pressure_connection_1.png';
      case MeasurementGuideImage.connectBp2:
        return 'assets/images/measurement/guide/blood_pressure_connection_2.png';
      case MeasurementGuideImage.connectBp3:
        return 'assets/images/measurement/guide/blood_pressure_connection_3.png';
      case MeasurementGuideImage.manualBp1:
        return 'assets/images/measurement/guide/blood_pressure_manual_1.png';
      case MeasurementGuideImage.manualBp2:
        return 'assets/images/measurement/guide/blood_pressure_manual_2.png';

      case MeasurementGuideImage.measureWeight1:
        return 'assets/images/measurement/guide/weight_measure_1.png';
      case MeasurementGuideImage.measureWeight2:
        return 'assets/images/measurement/guide/weight_measure_2.png';  
      case MeasurementGuideImage.measureWeight3:
        return 'assets/images/measurement/guide/weight_measure_3.png';
      case MeasurementGuideImage.connectWeight1:
        return 'assets/images/measurement/guide/weight_connection_1.png';
      case MeasurementGuideImage.connectWeight2:
        return 'assets/images/measurement/guide/weight_connection_2.png';

      case MeasurementGuideImage.connectTeperature1:
        return 'assets/images/measurement/guide/connect_temperature_1.png';
      case MeasurementGuideImage.connectTeperature2:
        return 'assets/images/measurement/guide/connect_temperature_2.png';
      case MeasurementGuideImage.measureTemperature1:
        return 'assets/images/measurement/guide/measure_temperature_1.png';
      case MeasurementGuideImage.measureTemperature2:
        return 'assets/images/measurement/guide/measure_temperature_2.png';
    }
  }

  static List<String> get bloodPressureGuides => [
        MeasurementGuideImage.measureBp1.path,
        MeasurementGuideImage.measureBp2.path,
        MeasurementGuideImage.measureBp3.path,
      ];

  static List<String> get bloodPressureConnectGuides => [
        MeasurementGuideImage.connectBp1.path,
        MeasurementGuideImage.connectBp2.path,
        MeasurementGuideImage.connectBp3.path,
      ];

  static List<String> get bloodPressureManualGuides => [
        MeasurementGuideImage.manualBp1.path,
        MeasurementGuideImage.manualBp2.path,
      ];

  static List<String> get weightGuides => [
        MeasurementGuideImage.measureWeight1.path,
        MeasurementGuideImage.measureWeight2.path,
        MeasurementGuideImage.measureWeight3.path,
      ];

  static List<String> get weightConnectGuides => [
        MeasurementGuideImage.connectWeight1.path,
        MeasurementGuideImage.connectWeight2.path,
      ];

  static List<String> get temperatureGuides => [
        MeasurementGuideImage.connectTeperature1.path,
        MeasurementGuideImage.connectTeperature2.path,
      ];

  static List<String> get measureTemperatureGuides => [
        MeasurementGuideImage.measureTemperature1.path,
        MeasurementGuideImage.measureTemperature2.path,
      ];
}
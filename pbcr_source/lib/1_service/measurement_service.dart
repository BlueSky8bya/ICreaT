import 'package:icreat_dct/3_view/navbar/measurement/data/measurement_type.dart';
import 'package:icreat_dct/6_util/listener.dart';

class MeasurementServiceEvent {
  final MeasurementType measurementType;
  final String itemGroupUid;
  // 현재
  // systole: int, diastole: int, pulse: int, measureTime: DateTime
  // weight: double, measureTime: DateTime
  // temperature: double, measureTime: DateTime
  // sleptAt: DateTime, sleepDuration: int, wokeUpAt: DateTime, measureTime: DateTime
  // stepCount: int, measureTime: DateTime
  final Map<String, dynamic> data;

  MeasurementServiceEvent({
    required this.measurementType,
    required this.itemGroupUid,
    required this.data,
  });

  @override
  String toString() {
    return 'MeasurementServiceEvent(measurementType: $measurementType, itemGroupKey: $itemGroupUid, data: $data)';
  }
}

class MeasurementService {
  MeasurementService();

  final ValueListener<MeasurementServiceEvent> _eventListener = ValueListener();

  int addEvent(Function(MeasurementServiceEvent) listener) =>
      _eventListener.add(listener);

  void removeEvent(int? id) => _eventListener.remove(id);

  void addBp(
    String itemGroupKey, {
    required int systole,
    required int diastole,
    required int pulse,
  }) {
    _eventListener.notify(MeasurementServiceEvent(
      measurementType: MeasurementType.bloodPressure,
      itemGroupUid: itemGroupKey,
      data: {
        'systole': systole,
        'diastole': diastole,
        'pulse': pulse,
      },
    ));
  }

  void addWeight(
    String itemGroupKey, {
    required double weight,
  }) {
    _eventListener.notify(MeasurementServiceEvent(
      measurementType: MeasurementType.bodyWeight,
      itemGroupUid: itemGroupKey,
      data: {
        'weight': weight,
      },
    ));
  }

  void addTemperature(
    String itemGroupKey, {
    required double temperature,
  }) {
    _eventListener.notify(MeasurementServiceEvent(
      measurementType: MeasurementType.temperature,
      itemGroupUid: itemGroupKey,
      data: {
        'temperature': temperature,
      },
    ));
  }

  void addSleep(
    String itemGroupKey, {
    required DateTime sleptAt,
    required int sleepDuration,
    required DateTime wokeUpAt,
  }) {
    _eventListener.notify(MeasurementServiceEvent(
      measurementType: MeasurementType.sleep,
      itemGroupUid: itemGroupKey,
      data: {
        'sleptAt': sleptAt,
        'sleepDuration': sleepDuration,
        'wokeUpAt': wokeUpAt,
      },
    ));
  }

  void addStep(
    String itemGroupKey, {
    required int stepCount,
  }) {
    _eventListener.notify(MeasurementServiceEvent(
      measurementType: MeasurementType.step,
      itemGroupUid: itemGroupKey,
      data: {
        'stepCount': stepCount,
      },
    ));
  }
}

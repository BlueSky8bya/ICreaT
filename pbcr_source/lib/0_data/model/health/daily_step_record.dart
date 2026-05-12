import 'package:icreat_dct/0_data/model/health/step_model.dart';

class DailyStepRecord {
  const DailyStepRecord({
    required this.date,
    required this.stepDataList,
  });

  final DateTime date;
  final List<StepModel> stepDataList;

  int get totalStepCount => stepDataList.fold(
      0, (previousValue, element) => previousValue + element.count);

  factory DailyStepRecord.empty([DateTime? dt]) {
    return DailyStepRecord(
      date: dt ?? DateTime.now(),
      stepDataList: [],
    );
  }
}
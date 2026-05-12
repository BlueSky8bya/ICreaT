/// 10분 단위의 걸음 수를 저장하는 모델
class StepModel {
  final int count;
  final DateTime date;

  const StepModel({required this.count, required this.date});

  @override
  String toString() => 'StepModel(count: $count, date: $date)';
}

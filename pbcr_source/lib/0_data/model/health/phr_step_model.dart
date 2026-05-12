import 'dart:convert';

class PhrStep {
  final int recordDateTime;
  final int stepCount;
  final bool isPosted;

  PhrStep({
    required this.recordDateTime,
    required this.stepCount,
    required this.isPosted,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': recordDateTime,
      'stepCnt': stepCount,
      'isPosted': isPosted,
    };
  }

  factory PhrStep.fromMap(Map<String, dynamic> map) {
    return PhrStep(
      recordDateTime: map['time'],
      stepCount: map['stepCnt'],
      isPosted: map['isPosted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PhrStep.fromJson(String source) =>
      PhrStep.fromMap(json.decode(source));
}

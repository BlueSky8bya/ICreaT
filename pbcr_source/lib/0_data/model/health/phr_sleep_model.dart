import 'dart:convert';

class PhrSleep {
  final String recordDate;
  final int startTime;
  final int endTime;
  final bool isPosted;

  PhrSleep({
    required this.recordDate,
    required this.startTime,
    required this.endTime,
    required this.isPosted,
  });

  Map<String, dynamic> toMap() {
    return {
      'recordDate': recordDate,
      'startTime': startTime,
      'endTime': endTime,
      'isPosted': isPosted,
    };
  }

  factory PhrSleep.fromMap(Map<String, dynamic> map) {
    return PhrSleep(
      recordDate: map['recordDate'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      isPosted: map['isPosted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PhrSleep.fromJson(String source) =>
      PhrSleep.fromMap(json.decode(source));
}

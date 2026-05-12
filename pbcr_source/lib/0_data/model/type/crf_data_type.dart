import 'package:json_annotation/json_annotation.dart';

enum CrfDataType {
  @JsonValue("String")
  string,
  @JsonValue("Integer")
  integer,
  @JsonValue("Float")
  float,
  @JsonValue("Date")
  date,
  unknown,
  @JsonValue("Text")
  text,
  @JsonValue("Date_Limited")
  dateLimited,
  @JsonValue("Time")
  time,
}

extension CrfDataTypeExtension on String {
  CrfDataType toCrfDataType() {
    return CrfDataType.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == toLowerCase(),
      orElse: () => CrfDataType.unknown,
    );
  }
}

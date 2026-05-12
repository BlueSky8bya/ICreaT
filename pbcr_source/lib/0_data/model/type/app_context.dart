import 'package:json_annotation/json_annotation.dart';

enum AppContext {
  @JsonValue('MAIN')
  main,
  @JsonValue('LITE')
  lite,
  @JsonValue('ARCHIVE')
  archive;
}

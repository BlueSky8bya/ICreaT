import 'package:json_annotation/json_annotation.dart';

enum EPROFormDbMode {
  @JsonValue('new')
  create,
  @JsonValue('upd')
  update,
}
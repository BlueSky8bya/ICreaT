import 'package:json_annotation/json_annotation.dart';

part 'icreat_res.g.dart';

@JsonSerializable()
class ICreatRes {
  @JsonKey(name: '_RSLT_VAL')
  final String? resultValue;
  @JsonKey(name: '_RSLT_MSG')
  final String? resultMessge;

  const ICreatRes({
    this.resultValue,
    this.resultMessge,
  });

  factory ICreatRes.fromJson(Map<String, dynamic> json) =>
      _$ICreatResFromJson(json);
  Map<String, dynamic> toJson() => _$ICreatResToJson(this);

  bool get isSuccess => resultValue == 'SUCCESS';
}

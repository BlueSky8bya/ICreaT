import 'package:json_annotation/json_annotation.dart';

part 'esource_upload_res.g.dart';

@JsonSerializable()
class ESourceUploadRes {
  @JsonKey(name: 'success')
  final String success;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'errMessage')
  final String? errMessage;

  const ESourceUploadRes({
    required this.success,
    this.status,
    this.errMessage,
  });

  factory ESourceUploadRes.fromJson(Map<String, dynamic> json) =>
      _$ESourceUploadResFromJson(json);

  Map<String, dynamic> toJson() => _$ESourceUploadResToJson(this);

  bool get isSuccess => success == 'Y';
}

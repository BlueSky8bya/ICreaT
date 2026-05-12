import 'package:json_annotation/json_annotation.dart';

part 'login_req.g.dart';

@JsonSerializable()
class LoginReq {
  @JsonKey(name: 'project_id')
  final String projectId;
  @JsonKey(name: 'subject_id')
  final String subjectId;
  @JsonKey(name: 'password')
  final String password;

  const LoginReq({
    required this.projectId,
    required this.subjectId,
    required this.password,
  });

  factory LoginReq.fromJson(Map<String, dynamic> json) =>
      _$LoginReqFromJson(json);

  Map<String, dynamic> toJson() => _$LoginReqToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/auth/login_result.dart';

part 'login_result_res.g.dart';

// {
//   "_RSLT_VAL": "SUCCESS",
//   "dct_session_id": ""
// }
// 또는
// {
//   "_RSLT_VAL": "ERROR",
//   "_RSLT_MSG": ""
// }

@JsonSerializable()
class LoginResultRes {
  @JsonKey(name: '_RSLT_VAL')
  final String resultValue;
  @JsonKey(name: 'Dct-Session-Id')
  final String? dctSessionId;
  @JsonKey(name: '_RSLT_MSG')
  final String? resultMessage;
  @JsonKey(name: 'pid')
  final int? pid;
  @JsonKey(name: 'organ_cd')
  final String? organCode;
  @JsonKey(name: 'pat_name')
  final String? patName;

  const LoginResultRes({
    required this.resultValue,
    this.dctSessionId,
    this.resultMessage,
    this.pid,
    this.organCode,
    this.patName,
  });

  factory LoginResultRes.fromJson(Map<String, dynamic> json) => _$LoginResultResFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResultResToJson(this);
}

extension LoginResultResExt on LoginResultRes {
  LoginResult toModel() => LoginResult(
        dctSessionId: dctSessionId ?? '',
        pid: pid?.toString() ?? '',
        organCode: organCode ?? '',
        patName: patName ?? '',
      );
}

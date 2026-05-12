class LoginResult {
  final String dctSessionId;
  final String pid;
  final String organCode;
  final String patName;

  const LoginResult({
    required this.dctSessionId,
    required this.pid,
    required this.organCode,
    required this.patName,
  });

  @override
  String toString() {
    return 'LoginRes(dctSessionId: $dctSessionId, pid: $pid, organCode: $organCode, patName: $patName)';
  }

  /// 로그인 성공 여부를 판단합니다.
  /// dctSessionId가 비어있지 않으면 성공으로 간주합니다.
  bool get isSuccess => dctSessionId.isNotEmpty;
}

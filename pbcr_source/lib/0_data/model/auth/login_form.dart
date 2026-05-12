class LoginForm {
  final String userId;
  final String password;

  const LoginForm({
    required this.userId,
    required this.password,
  });

  bool get isValid => userId.isNotEmpty && password.isNotEmpty;
}

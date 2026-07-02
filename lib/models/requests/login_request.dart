class LoginRequest {
  final String login;
  final String password;

  const LoginRequest({required this.login, required this.password});

  factory LoginRequest.fromJson(Map<String, Object> json) {
    return LoginRequest(
      login: json["login"] as String,
      password: json["password"] as String,
    );
  }

  Map<String, Object> toJson() {
    return {"login": login, "password": password};
  }
}

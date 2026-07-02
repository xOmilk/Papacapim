class LoginRequest {
  final String login;
  final String password;

  const LoginRequest({required this.login, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      login: json["login"] as String,
      password: json["password"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {"login": login, "password": password};
  }
}

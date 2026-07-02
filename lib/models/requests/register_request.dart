class RegisterRequest {
  final String login;
  final String name;
  final String password;
  final String passwordConfirmation;

  const RegisterRequest({
    required this.login,
    required this.name,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RegisterRequest.fromJson(Map<String, Object> json) {
    return RegisterRequest(
      login: json["login"] as String,
      name: json["name"] as String,
      password: json["password"] as String,
      passwordConfirmation: json["passwordConfirmation"] as String,
    );
  }

  Map<String, Object> toJson() {
    return {
      "user": {
        "login": login,
        "name": name,
        "password": password,
        "passwordConfirmation": passwordConfirmation,
      },
    };
  }
}

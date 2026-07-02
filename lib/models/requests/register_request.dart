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

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;

    return RegisterRequest(
      login: user['login'] as String,
      name: user['name'] as String,
      password: user['password'] as String,
      passwordConfirmation: user['passwordConfirmation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
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

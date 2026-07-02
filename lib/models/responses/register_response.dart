class RegisterResponse {
  final String login;
  final String name;
  final DateTime createdAt;

  const RegisterResponse({
    required this.login,
    required this.name,
    required this.createdAt,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      login: json["login"],
      name: json["name"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"login": login, "name": name, "created_at": createdAt};
  }
}

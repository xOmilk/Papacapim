class LoginResponse {
  final String userLogin;
  final String token;
  final String ip;

  const LoginResponse({
    required this.userLogin,
    required this.token,
    required this.ip,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userLogin: json["user_login"] as String,
      token: json["token"] as String,
      ip: json["ip"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {"user_login": userLogin, "token": token, "ip": ip};
  }
}

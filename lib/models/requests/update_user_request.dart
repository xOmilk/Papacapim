class UpdateUserRequest {
  final String? login;
  final String? name;
  final String? password;
  final String? passwordConfirmation;
  final String? imageData;

  UpdateUserRequest({
    this.login,
    this.name,
    this.password,
    this.passwordConfirmation,
    this.imageData,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      UpdateUserRequest(
        login: json["login"],
        name: json["name"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
        imageData: json["image_data"],
      );

  Map<String, dynamic> toJson() {
    return {
      "login": login,
      "name": name,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "image_data": imageData,
    };
  }
}

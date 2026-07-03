class UserResponse {
  final String login;
  final String name;
  final String? profileImage;
  final int? followersNumber;
  final int? followingNumber;

  const UserResponse({
    required this.login,
    required this.name,
    this.profileImage,
    this.followersNumber,
    this.followingNumber,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      login: json["login"],
      name: json["name"],
      profileImage: json["profile_image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"login": login, "name": name, "profile_image": profileImage};
  }
}

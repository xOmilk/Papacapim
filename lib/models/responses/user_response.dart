class UserResponse {
  final String login;
  final String name;
  final String? profileImage;
  final int? followersNumber;
  final int? followingNumber;
  final bool? youFollow;
  final bool? followsYou;

  const UserResponse({
    required this.login,
    required this.name,
    this.profileImage,
    this.followersNumber,
    this.followingNumber,
    this.youFollow,
    this.followsYou,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      login: json["login"],
      name: json["name"],
      profileImage: json["profile_image"],
      followersNumber: json["followers_number"],
      followingNumber: json["following_number"],
      youFollow: json["you_follow"],
      followsYou: json["follows_you"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "login": login,
      "name": name,
      "profile_image": profileImage,
      "followers_number": followersNumber,
      "following_number": followingNumber,
      "you_follow": youFollow,
      "follows_you": followsYou,
    };
  }
}

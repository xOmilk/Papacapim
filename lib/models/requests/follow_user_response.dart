class FollowUserResponse {
  final String followerLogin;

  const FollowUserResponse({required this.followerLogin});

  factory FollowUserResponse.fromJson(Map<String, dynamic> json) {
    return FollowUserResponse(followerLogin: json["follower_login"]);
  }

  Map<String, dynamic> toJson() {
    return {"follower_login": followerLogin};
  }
}

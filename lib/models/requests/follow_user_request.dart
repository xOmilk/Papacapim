class FollowUserRequest {
  final String followerLogin;

  const FollowUserRequest({required this.followerLogin});

  factory FollowUserRequest.fromJson(Map<String, dynamic> json) {
    return FollowUserRequest(followerLogin: json["follower_login"]);
  }

  Map<String, dynamic> toJson() {
    return {"follower_login": followerLogin};
  }
}

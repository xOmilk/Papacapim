import 'package:flutter_project/models/responses/user_response.dart';

class ListFollowersResponse {
  final UserResponse follower;

  const ListFollowersResponse({required this.follower});

  factory ListFollowersResponse.fromJson(Map<String, dynamic> json) {
    return ListFollowersResponse(
      follower: UserResponse.fromJson(json["follower"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"follower": follower.toJson()};
  }
}

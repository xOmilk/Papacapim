import 'package:flutter_project/models/responses/user_response.dart';

class MediaResponse {
  final String mediumType;
  final String mediumUrl;

  MediaResponse({required this.mediumType, required this.mediumUrl});

  factory MediaResponse.fromJson(Map<String, dynamic> json) {
    return MediaResponse(
      mediumType: json['medium_type'] as String,
      mediumUrl: json['medium_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medium_type': mediumType,
      'medium_url': mediumUrl,
    };
  }
}

class PostResponse {
  final int id;
  final int? postId;
  final String message;
  final DateTime createdAt;
  final int likesNumber;
  final int repliesNumber;
  final bool youLiked;
  final UserResponse? user;
  final List<MediaResponse>? media;

  const PostResponse({
    required this.id,
    this.postId,
    required this.message,
    required this.createdAt,
    required this.likesNumber,
    required this.repliesNumber,
    required this.youLiked,
    this.user,
    this.media,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json["id"],
      postId: json["post_id"],
      message: json["message"],
      createdAt: DateTime.parse(json["created_at"]),
      likesNumber: json["likes_number"],
      repliesNumber: json["replies_number"],
      youLiked: json["you_liked"] ?? false,
      user: json["user"] != null ? UserResponse.fromJson(json["user"]) : null,
      media: json["media"] != null
          ? (json["media"] as List)
              .map((e) => MediaResponse.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "post_id": postId,
      "message": message,
      "created_at": createdAt.toIso8601String(),
      "likes_number": likesNumber,
      "replies_number": repliesNumber,
      "you_liked": youLiked,
      "user": user?.toJson(),
      "media": media?.map((e) => e.toJson()).toList(),
    };
  }
}

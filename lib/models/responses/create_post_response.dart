class CreatePostResponse {
  final int id;
  final int? postId;
  final String message;
  final DateTime createdAt;

  const CreatePostResponse({
    required this.id,
    this.postId,
    required this.message,
    required this.createdAt,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    return CreatePostResponse(
      id: json['id'] as int,
      postId: json['post_id'] as int?,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

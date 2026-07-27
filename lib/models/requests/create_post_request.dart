class CreatePostRequest {
  final String message;

  CreatePostRequest({required this.message});

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) {
    final post = json['post'] as Map<String, dynamic>;
    return CreatePostRequest(
      message: post['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "post": {
        "message": message,
      },
    };
  }
}

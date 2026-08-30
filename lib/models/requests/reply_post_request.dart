class ReplyPostRequest {
  final String message;

  ReplyPostRequest({required this.message});

  factory ReplyPostRequest.fromJson(Map<String, dynamic> json) {
    final reply = json['reply'] as Map<String, dynamic>;

    return ReplyPostRequest(message: reply['message'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "reply": {"message": message},
    };
  }
}

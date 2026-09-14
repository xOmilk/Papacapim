class Media {
  String medium_type;
  String medium_data;

  Media(this.medium_data, this.medium_type);

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      json['medium_data'] as String,
      json['medium_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "medium_type": medium_type,
      "medium_data": medium_data,
    };
  }
}

class CreatePostRequest {
  final String message;
  List<Media>? media;

  CreatePostRequest({required this.message, this.media});

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) {
    return CreatePostRequest(
      message: json['message'] as String,
      media: json['media'] != null
          ? (json['media'] as List<dynamic>)
              .map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "message": message,
    };

    if (media != null && media!.isNotEmpty) {
      data["media"] = media!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}


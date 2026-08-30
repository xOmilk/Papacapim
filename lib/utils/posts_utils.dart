import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:go_router/go_router.dart';

class PostsUtils {
  static void onPostTap(BuildContext context, PostResponse post) {
    context.push("/post", extra: post);
  }
}

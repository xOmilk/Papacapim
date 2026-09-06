import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:go_router/go_router.dart';

class UsersUtils {
  static void onPostTap(BuildContext context, UserResponse user) {
    context.push("/profile", extra: user.login);
  }
}

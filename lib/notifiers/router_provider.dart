import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/ui/screens/auth/auth_screen.dart';
import 'package:flutter_project/ui/screens/home/home_screen.dart';
import 'package:flutter_project/ui/screens/posts/create_post_screen.dart';
import 'package:flutter_project/ui/screens/posts/see_post.dart';
import 'package:flutter_project/ui/screens/posts/see_post_by_id.dart';
import 'package:flutter_project/ui/screens/user/edit_profile.dart';
import 'package:flutter_project/ui/screens/user/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final Provider<GoRouter> routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: "/", builder: (context, state) => const HomeScreen()),
      GoRoute(path: "/auth", builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: "/my-profile",
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: "/edit-profile",
        builder: (context, state) => const EditProfile(),
      ),
      GoRoute(
        path: "/profile",
        builder: (context, state) {
          var login = state.extra as String;
          return ProfileScreen(login: login);
        },
      ),
      GoRoute(
        path: "/post",
        builder: (context, state) {
          final post = state.extra as PostResponse;
          return SeePost(post: post);
        },
      ),
      GoRoute(
        path: "/post-by-id",
        builder: (context, state) {
          final postId = state.extra as int;
          return SeePostById(postId: postId);
        },
      ),
      GoRoute(
        path: "/create-post",
        builder: (context, state) => const CreatePostScreen(),
      ),
    ],
  );
});

import 'package:flutter/material.dart';
import 'package:flutter_project/services/prefs_service.dart';
import 'package:flutter_project/ui/screens/auth/auth_screen.dart';
import 'package:flutter_project/ui/screens/home/home_screen.dart';
import 'package:flutter_project/themes/app_theme.dart';
import 'package:flutter_project/ui/screens/posts/create_post_screen.dart';
import 'package:flutter_project/ui/screens/posts/see_post.dart';
import 'package:flutter_project/ui/screens/user/edit_profile.dart';
import 'package:flutter_project/ui/screens/user/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsService.init();
  runApp(ProviderScope(child: MyApp()));
}

final GoRouter _goRouter = GoRouter(
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
      path: "/profile/:login",
      builder: (context, state) {
        var login = state.pathParameters["login"];
        return ProfileScreen(login: login);
      },
    ),
    GoRoute(
      path: "/post/:id",
      builder: (context, state) {
        var param = state.pathParameters["id"];
        if (param == null) return HomeScreen();

        var id = int.tryParse(param);
        if (id == null) return HomeScreen();

        return SeePost(id: id);
      },
    ),
    GoRoute(
      path: "/create-post",
      builder: (context, state) => const CreatePostScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      routerConfig: _goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

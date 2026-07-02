import 'package:flutter/material.dart';
import 'package:flutter_project/services/prefs_service.dart';
import 'package:flutter_project/ui/screens/auth/auth_screen.dart';
import 'package:flutter_project/ui/screens/home_screen.dart';
import 'package:flutter_project/themes/app_theme.dart';
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

import 'package:flutter/material.dart';
import 'package:flutter_project/services/prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PrefsService prefsService = PrefsService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (prefsService.getToken() == null) {
        context.replace("/auth");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.grass, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 4),
            Text(
              "Papacapim",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: "Sora",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_project/notifiers/router_provider.dart';
import 'package:flutter_project/services/prefs_service.dart';
import 'package:flutter_project/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsService.init();
  await initializeDateFormatting('pt_BR', null);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

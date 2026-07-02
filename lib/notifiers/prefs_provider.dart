import 'package:flutter_project/services/prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final prefsProvider = Provider<PrefsService>((ref) {
  return PrefsService();
});

final tokenProvider = Provider<String?>((ref) {
  final prefs = ref.watch(prefsProvider);
  return prefs.getToken();
});

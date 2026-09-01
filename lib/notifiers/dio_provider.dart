import 'package:flutter_project/notifiers/prefs_provider.dart';
import 'package:flutter_project/notifiers/router_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  final token = ref.watch(tokenProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.papacapim.just.pro.br',
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers.addAll({"x-session-token": token});
        handler.next(options);
      },
      onError: (DioException error, handler) {
        if (error.response?.statusCode == 401) {
          ref.read(routerProvider).go('/auth');
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});

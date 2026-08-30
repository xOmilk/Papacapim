import 'package:dio/dio.dart';
import 'package:flutter_project/notifiers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeRepository {
  final Dio _dio;

  LikeRepository({required this._dio});

  Future<void> likePost(int postId) async {
    try {
      await _dio.post("/posts/$postId/likes");
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dislikePost(int postId) async {
    try {
      await _dio.delete("/posts/$postId/likes/me");
      return;
    } catch (e) {
      rethrow;
    }
  }
}

final likeRepositoryProvider = Provider<LikeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LikeRepository(dio: dio);
});

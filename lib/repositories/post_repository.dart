import 'package:dio/dio.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/notifiers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostRepository {
  final Dio _dio;

  PostRepository({required Dio dio}) : _dio = dio;

  Future<List<PostResponse>> getPosts(String login) async {
    try {
      final postsResponse = await _dio.get("/users/$login/posts");
      return (postsResponse.data as List)
          .map((post) => PostResponse.fromJson(post))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final dio = ref.read(dioProvider);
  return PostRepository(dio: dio);
});

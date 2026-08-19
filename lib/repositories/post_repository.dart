import 'package:dio/dio.dart';
import 'package:flutter_project/models/requests/create_post_request.dart';
import 'package:flutter_project/models/responses/create_post_response.dart';
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePostResponse> createNewPost(
    CreatePostRequest postRequest,
  ) async {
    try {
      final createPostResponse = await _dio.post(
        "/posts",
        data: postRequest.toJson(),
      );

      return CreatePostResponse.fromJson(createPostResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deletePost(int postId) async {
    try {
      await _dio.delete("/posts/$postId");
      return "Sua publicação foi excluida.";
    } catch (e) {
      rethrow;
    }
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PostRepository(dio: dio);
});

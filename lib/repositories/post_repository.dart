import 'package:dio/dio.dart';
import 'package:flutter_project/models/requests/create_post_request.dart';
import 'package:flutter_project/models/requests/reply_post_request.dart';
import 'package:flutter_project/models/responses/create_post_response.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/notifiers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostRepository {
  final Dio _dio;

  PostRepository({required this._dio});

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

  Future<PostResponse> createNewReply(
    int postId,
    ReplyPostRequest replyPostRequest,
  ) async {
    try {
      final createReplyResponse = await _dio.post(
        "/posts/$postId/replies",
        data: replyPostRequest.toJson(),
      );

      return PostResponse.fromJson(createReplyResponse.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostResponse>> getPosts({
    int? page = 0,
    int? feed = 0,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'feed': feed,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim().toString(),
    };

    try {
      final postsResponse = await _dio.get(
        "/posts",
        queryParameters: queryParams,
      );
      return (postsResponse.data as List)
          .map((post) => PostResponse.fromJson(post))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return List.empty();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostResponse>> getUserPosts(String login) async {
    try {
      final postsResponse = await _dio.get("/users/$login/posts");
      return (postsResponse.data as List)
          .map((post) => PostResponse.fromJson(post))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return List.empty();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostResponse>> getReplies(int postId) async {
    try {
      final repliesResponse = await _dio.get("/posts/$postId/replies");
      return (repliesResponse.data as List)
          .map((post) => PostResponse.fromJson(post))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return List.empty();
      }
      rethrow;
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

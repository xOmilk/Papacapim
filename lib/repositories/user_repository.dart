import 'package:dio/dio.dart';
import 'package:flutter_project/models/requests/follow_user_response.dart';
import 'package:flutter_project/models/requests/update_user_request.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/notifiers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final Dio _dio;

  UserRepository({required this._dio});

  Future<UserResponse> getUser(String login) async {
    try {
      final response = await _dio.get("/users/$login");
      return UserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserResponse>> listUsers({
    int? page = 0,

    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      if (search != null && search.trim().isNotEmpty) 'search': search.trim().toString(),
    };

    try {
      final users = await _dio.get('/users', queryParameters: queryParams);
      return (users.data as List)
          .map((user) => UserResponse.fromJson(user))
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

  Future<void> updateUser(UpdateUserRequest updateUserRequest) async {
    try {
      await _dio.patch("/users/1", data: updateUserRequest.toJson());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<FollowUserResponse> followUser(String login) async {
    try {
      final response = await _dio.post("/users/$login/followers");
      return FollowUserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unfollowUser(String login) async {
    try {
      await _dio.delete("/users/$login/followers/me");
      return;
    } catch (e) {
      rethrow;
    }
  }
}

final usersRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio: dio);
});

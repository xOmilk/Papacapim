import 'package:dio/dio.dart';
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

  Future<void> updateUser(UpdateUserRequest updateUserRequest) async {
    try {
      await _dio.patch("/users/1", data: updateUserRequest.toJson());
    } catch (e) {
      rethrow;
    }
  }
}

final usersRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio: dio);
});

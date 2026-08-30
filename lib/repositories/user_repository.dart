import 'package:dio/dio.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/notifiers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final Dio _dio;

  UserRepository({required Dio dio}) : _dio = dio;

  Future<UserResponse> getUser(String login) async {
    try {
      final response = await _dio.get("/users/$login");
      return UserResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

final usersRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio: dio);
});

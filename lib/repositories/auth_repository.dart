import 'package:dio/dio.dart';
import 'package:flutter_project/models/requests/login_request.dart';
import 'package:flutter_project/models/requests/register_request.dart';
import 'package:flutter_project/models/responses/login_response.dart';
import 'package:flutter_project/models/responses/register_response.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/notifiers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({required this._dio});

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post("/sessions", data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final responseRegister = await _dio.post(
        "/users",
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(responseRegister.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse> getMyProfile() async {
    try {
      final myInfo = await _dio.get("/users/me");
      return UserResponse.fromJson(myInfo.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // await _dio.delete("");
    } catch (e) {
      rethrow;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio: dio);
});

import 'package:dio/dio.dart';
import 'package:flutter_project/models/requests/login_request.dart';
import 'package:flutter_project/models/requests/register_request.dart';
import 'package:flutter_project/models/responses/login_response.dart';
import 'package:flutter_project/models/responses/register_response.dart';
import 'package:flutter_project/notifiers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({required Dio dio}) : _dio = dio;

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post("/sessions", data: request.toJson());

      print(LoginResponse.fromJson(response.data).toString());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      print("Erro ao fazer login");
      rethrow;
    }
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final responseRegister = await _dio.post(
        "/register",
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(responseRegister.data);
    } catch (e) {
      print("Erro ao se registrar");
      rethrow;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepository(dio: dio);
});

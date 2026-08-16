import 'package:dio/dio.dart';

class PostRepository {
  final Dio _dio;

  PostRepository({required Dio dio}) : _dio = dio;

  //Future<PostResponse> getPosts() async {}
}

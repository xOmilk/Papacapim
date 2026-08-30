import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myPostsProvider = FutureProvider.family<List<PostResponse>, String>((
  ref,
  login,
) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getUserPosts(login);
});

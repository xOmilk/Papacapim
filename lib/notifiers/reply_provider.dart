import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final repliesProvider = FutureProvider.family<List<PostResponse>, int>((
  ref,
  postId,
) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getReplies(postId);
});

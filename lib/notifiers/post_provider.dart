import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PostQuery = ({int? feed, int? page, String? search});

final postProvider = FutureProvider.family<List<PostResponse>, PostQuery>((
  ref,
  postQuery,
) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPosts(
    page: postQuery.page,
    feed: postQuery.feed,
    search: postQuery.search,
  );
});

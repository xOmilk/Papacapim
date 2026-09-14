import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/notifiers/post_provider.dart';

typedef FeedParams = ({int? feed, String? search});

class FeedState {
  final List<PostResponse> posts;
  final int page;

  FeedState({required this.posts, required this.page});

  FeedState copyWith({List<PostResponse>? posts, int? page}) =>
      FeedState(posts: posts ?? this.posts, page: page ?? this.page);
}

class FeedNotifier extends AsyncNotifier<FeedState> {
  FeedNotifier(this.params);

  final FeedParams params;

  @override
  Future<FeedState> build() async {
    final firstPage = await ref.watch(
      postProvider((feed: params.feed, page: 0, search: params.search)).future,
    );
    return FeedState(posts: firstPage, page: 0);
  }

  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || state.isLoading) return;

    final nextPage = current.page + 1;
    final newPosts = await ref.read(
      postProvider((
        feed: params.feed,
        page: nextPage,
        search: params.search,
      )).future,
    );

    state = AsyncData(
      current.copyWith(posts: [...current.posts, ...newPosts], page: nextPage),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firstPage = await ref.read(
        postProvider((
          feed: params.feed,
          page: 0,
          search: params.search,
        )).future,
      );
      return FeedState(posts: firstPage, page: 0);
    });
  }
}

final feedProvider =
    AsyncNotifierProvider.family<FeedNotifier, FeedState, FeedParams>(
      FeedNotifier.new,
    );

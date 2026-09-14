import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project/notifiers/feed_notifier.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:flutter_project/utils/posts_utils.dart';

class FeedListView extends ConsumerStatefulWidget {
  final FeedParams params;

  const FeedListView({super.key, required this.params});

  @override
  ConsumerState<FeedListView> createState() => _FeedListViewState();
}

class _FeedListViewState extends ConsumerState<FeedListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(feedProvider(widget.params).notifier).loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider(widget.params));

    return feedState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text("Erro: $error")),
      data: (state) => RefreshIndicator(
        onRefresh: () =>
            ref.read(feedProvider(widget.params).notifier).refresh(),
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            if (state.posts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 64),
                child: Center(
                  child: Text(
                    "Não há nenhum post aqui",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }

            if (index >= state.posts.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return InkWell(
              onTap: () => PostsUtils.onPostTap(context, state.posts[index]),
              child: Post(postResponse: state.posts[index], maxLines: 5),
            );
          },
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Divider(),
          ),
          itemCount: state.posts.length + 1,
        ),
      ),
    );
  }
}

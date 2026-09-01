import 'package:flutter_project/notifiers/post_provider.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:flutter_project/utils/posts_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends ConsumerWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postProvider((feed: 1, page: null, search: null)));

    return posts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text("Erro: $error")),
      data: (data) => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => InkWell(
          onTap: () => PostsUtils.onPostTap(context, data[index]),
          child: Post(postResponse: data[index], maxLines: 5),
        ),
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Divider(),
        ),
        itemCount: data.length,
      ),
    );
  }
}

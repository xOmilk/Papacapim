import 'package:flutter_project/notifiers/post_provider.dart';
import 'package:flutter_project/utils/posts_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/ui/components/post.dart';

class ForYouScreen extends ConsumerStatefulWidget {
  const ForYouScreen({super.key});

  @override
  ConsumerState<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends ConsumerState<ForYouScreen> {
  late Future<List<PostResponse>> posts;

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(
      postProvider((feed: null, page: null, search: null)),
    );

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

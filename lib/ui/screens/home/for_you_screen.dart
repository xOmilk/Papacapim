import 'package:flutter_project/repositories/post_repository.dart';
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
  void initState() {
    super.initState();

    final postRepo = ref.read(postRepositoryProvider);
    posts = postRepo.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erro: ${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("Perfil não encontrado."));
        }

        var data = snapshot.data!;

        return ListView.separated(
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
        );
      },
    );
  }
}

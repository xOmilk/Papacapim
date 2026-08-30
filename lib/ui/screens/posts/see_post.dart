import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/utils/posts_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:flutter_project/ui/components/reply_input.dart';
import 'package:go_router/go_router.dart';

class SeePost extends ConsumerStatefulWidget {
  final PostResponse post;

  const SeePost({required this.post, super.key});

  @override
  ConsumerState<SeePost> createState() => _SeePostState();
}

class _SeePostState extends ConsumerState<SeePost> {
  late Future<List<PostResponse>> replies;

  @override
  void initState() {
    super.initState();

    final postRepo = ref.read(postRepositoryProvider);
    replies = postRepo.getReplies(widget.post.id);
  }

  void onGoingBack() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? IconButton(onPressed: onGoingBack, icon: Icon(Icons.arrow_back))
            : null,
        title: Text("Post"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Post(postResponse: widget.post),
                  SizedBox(height: 16),
                  Text(
                    "Replies",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  SizedBox(height: 16),
                  ReplyInput(),
                ],
              ),
            ),
          ),
          FutureBuilder<List<PostResponse>>(
            future: replies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text("Erro: ${snapshot.error}")),
                );
              }

              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("Perfil não encontrado.")),
                );
              }

              final data = snapshot.data!;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                sliver: SliverList.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 2,
                          color: Theme.of(context).colorScheme.outline,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                PostsUtils.onPostTap(context, data[index]),
                            child: Post(postResponse: data[index], maxLines: 5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

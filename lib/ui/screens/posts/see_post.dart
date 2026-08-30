import 'package:flutter_project/notifiers/reply_provider.dart';
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
  void onGoingBack() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final replies = ref.watch(repliesProvider(widget.post.id));

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
                  Text(
                    "Replies",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  SizedBox(height: 16),
                  ReplyInput(postId: widget.post.id),
                ],
              ),
            ),
          ),

          replies.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

            error: (error, stack) =>
                SliverToBoxAdapter(child: Center(child: Text("Erro: $error"))),

            data: (data) {
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

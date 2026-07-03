import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:flutter_project/ui/components/reply_input.dart';
import 'package:go_router/go_router.dart';

class SeePost extends StatefulWidget {
  final int id;

  const SeePost({required this.id, super.key});

  @override
  State<SeePost> createState() => _SeePostState();
}

class _SeePostState extends State<SeePost> {
  PostResponse postResponse = PostResponse(
    id: 1,
    postId: null,
    message:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ante lectus, tempus id viverra vitae, porttitor et tortor. Integer et lobortis quam. Ut dignissim sodales molestie. Pellentesque vestibulum odio at ipsum vestibulum accumsan. Suspendisse posuere dignissim libero, sodales efficitur justo sagittis ultrices. Cras in tempor magna, quis accumsan lectus. Vestibulum ultricies est ac justo aliquam vulputate. Suspendisse molestie lacinia eros ut finibus. Suspendisse potenti. Duis iaculis, erat ac iaculis laoreet, ipsum massa porttitor neque, non imperdiet nibh diam vel justo. Fusce erat elit, venenatis et ultrices nec, dapibus nec risus. Fusce aliquam mattis mauris sit amet dignissim. Nunc tempus aliquet ipsum ac interdum. Suspendisse potenti.",
    createdAt: DateTime.now(),
    likesNumber: 10,
    repliesNumber: 1,
    youLiked: false,
    user: UserResponse(
      login: "luan",
      name: "Luan Coelho",
      profileImage:
          "https://upload.wikimedia.org/wikipedia/commons/4/49/Panthera_tigris_tigris.jpg",
    ),
  );

  List<PostResponse> replies = List<PostResponse>.filled(
    10,
    PostResponse(
      id: 2,
      postId: 1,
      message:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ante lectus, tempus id viverra vitae, porttitor et tortor. Integer et lobortis quam. Ut dignissim sodales molestie. Pellentesque vestibulum odio at ipsum vestibulum accumsan. Suspendisse posuere dignissim libero, sodales efficitur justo sagittis ultrices. Cras in tempor magna, quis accumsan lectus. Vestibulum ultricies est ac justo aliquam vulputate. Suspendisse molestie lacinia eros ut finibus. Suspendisse potenti. Duis iaculis, erat ac iaculis laoreet, ipsum massa porttitor neque, non imperdiet nibh diam vel justo. Fusce erat elit, venenatis et ultrices nec, dapibus nec risus. Fusce aliquam mattis mauris sit amet dignissim. Nunc tempus aliquet ipsum ac interdum. Suspendisse potenti.",
      createdAt: DateTime.now(),
      likesNumber: 10,
      repliesNumber: 1,
      youLiked: false,
      user: UserResponse(
        login: "luan",
        name: "Luan Coelho",
        profileImage:
            "https://upload.wikimedia.org/wikipedia/commons/4/49/Panthera_tigris_tigris.jpg",
      ),
    ),
  );

  void onGoingBack() {
    context.pop();
  }

  void onPostTap(PostResponse postResponse) {
    context.push("/post/${postResponse.id}");
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
                  Post(postResponse: postResponse),
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
          SliverPadding(
            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 16, 16),
            sliver: SliverList.builder(
              itemCount: replies.length,
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
                        onTap: () => onPostTap(replies[index]),
                        child: Post(postResponse: replies[index], maxLines: 5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

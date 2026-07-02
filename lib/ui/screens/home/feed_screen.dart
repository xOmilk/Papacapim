import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:go_router/go_router.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<PostResponse> posts = List.filled(
    10,
    PostResponse(
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
    ),
  );

  void onFabPress() {
    context.push("/create-post");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) => Post(postResponse: posts[index]),
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsetsGeometry.only(bottom: 8),
          child: Divider(),
        ),
        itemCount: posts.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onFabPress,
        child: Icon(Icons.add),
      ),
    );
  }
}

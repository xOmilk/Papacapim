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

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onFabPress() {
    context.push("/create-post");
  }

  void onPostTap(PostResponse postResponse) {
    context.push("/post/${postResponse.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Following"),
            Tab(text: "For you"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => InkWell(
              onTap: () => onPostTap(posts[index]),
              child: Post(postResponse: posts[index], maxLines: 5),
            ),
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(),
            ),
            itemCount: posts.length,
          ),
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => InkWell(
              onTap: () => onPostTap(posts[index]),
              child: Post(postResponse: posts[index], maxLines: 5),
            ),
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(),
            ),
            itemCount: posts.length,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onFabPress,
        child: const Icon(Icons.add),
      ),
    );
  }
}

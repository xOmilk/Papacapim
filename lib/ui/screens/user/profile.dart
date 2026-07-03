import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  final String? login;

  const ProfileScreen({this.login, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserResponse user = UserResponse(
    login: "luan",
    name: "Luan Coelho",
    profileImage:
        "https://upload.wikimedia.org/wikipedia/commons/4/49/Panthera_tigris_tigris.jpg",
  );

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
        title: Text(widget.login != null ? "Perfil" : "Meu perfil"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(100),
                      ),
                      child: Image.network(
                        user.profileImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 64);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "@${user.login}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemBuilder: (context, index) => Post(postResponse: posts[index]),
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsetsGeometry.only(bottom: 8),
                child: Divider(),
              ),
              itemCount: posts.length,
            ),
          ),
        ],
      ),
    );
  }
}

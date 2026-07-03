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
    followersNumber: 10000,
    followingNumber: 100,
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

  bool following = false;

  void onGoingBack() {
    context.pop();
  }

  void onEditTap() {
    context.push("/edit-profile");
  }

  void onLogoutButton() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sair da conta?"),
        content: Text("Você tem certeza que deseja sair da sua conta"),
        actions: [
          TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancelar",
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.error,
              ),
            ),
            onPressed: onLogout,
            child: Text("Sair"),
          ),
        ],
      ),
    );
  }

  void onLogout() {
    context.replace("/auth");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? IconButton(onPressed: onGoingBack, icon: Icon(Icons.arrow_back))
            : null,
        title: Text(widget.login != null ? "Perfil" : "Meu perfil"),
        actions: [
          if (widget.login == null)
            IconButton(onPressed: onEditTap, icon: Icon(Icons.edit)),
          if (widget.login == null)
            IconButton(onPressed: onLogoutButton, icon: Icon(Icons.logout)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (user.profileImage != null)
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(100),
                        ),
                        child: Image.network(
                          user.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 64);
                          },
                        ),
                      ),
                    ),
                  if (user.profileImage != null) SizedBox(height: 8),
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
                  SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Seguindo  ",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            Text(
                              (user.followingNumber ?? "?").toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight(700),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: VerticalDivider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Seguidores",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            Text(
                              (user.followersNumber ?? "?").toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight(700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (widget.login != null) SizedBox(height: 16),
                  if (widget.login != null)
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          following = !following;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          following
                              ? Theme.of(context).colorScheme.errorContainer
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(following ? "Deixar de seguir" : "Seguir"),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    "Posts",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight(700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemBuilder: (context, index) =>
                  Post(postResponse: posts[index], maxLines: 5),
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

import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/notifiers/prefs_provider.dart';
import 'package:flutter_project/repositories/auth_repository.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? login;

  const ProfileScreen({this.login, super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final UserResponse user = const UserResponse(
    login: "luan",
    name: "Luan Coelho",
    profileImage:
        "https://upload.wikimedia.org/wikipedia/commons/4/49/Panthera_tigris_tigris.jpg",
    followersNumber: 10000,
    followingNumber: 100,
  );

  late Future<UserResponse> myUserInfo;
  late Future<List<PostResponse>> myUserPosts;

  bool following = false;

  @override
  void initState() {
    super.initState();

    final prefs = ref.read(prefsProvider);

    final token = prefs.getToken();
    bool hasToken = token != null && token.isNotEmpty;

    if (!hasToken) {
      myUserInfo = Future.error("Não logado");
      myUserInfo.catchError((_) => const UserResponse(login: "", name: ""));

      myUserPosts = Future.error("Não logado");
      myUserPosts.catchError((_) => <PostResponse>[]);

      //Coloca o elemento pra ser carregado depois de terminar de desnhar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showMessage(context, "Você não está logado", isError: true);
          context.go("/auth");
        }
      });

      return;
    }

    final authRepo = ref.read(authRepositoryProvider);
    final postRepo = ref.read(postRepositoryProvider);

    myUserInfo = authRepo.getMyProfile();

    //Posts pelo meu login
    myUserPosts = myUserInfo.then((user) {
      return postRepo.getPosts(user.login);
    });
  }

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
      body: FutureBuilder<UserResponse>(
        future: myUserInfo,
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

          final user = snapshot.data!;

          return CustomScrollView(
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                ),
                                Text(
                                  (user.followingNumber ?? "?").toString(),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                ),
                                Text(
                                  (user.followersNumber ?? "?").toString(),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                            child: Text(
                              following ? "Deixar de seguir" : "Seguir",
                            ),
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
              FutureBuilder(
                future: myUserPosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text("Erro: ${snapshot.error}")),
                    );
                  }

                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: const Center(child: SizedBox.shrink()),
                    );
                  }

                  final posts = snapshot.data!;

                  if (posts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text("Nenhum post encontrado")),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) => Post(
                        postResponse: posts[index],
                        maxLines: 5,
                        onDelete: widget.login == null
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Excluir post?"),
                                    content: const Text(
                                      "Tem certeza que deseja excluir este post?",
                                    ),
                                    actions: [
                                      TextButton(
                                        style: const ButtonStyle(
                                          overlayColor: WidgetStatePropertyAll(
                                            Colors.transparent,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancelar",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                          ),
                                        ),
                                      ),
                                      FilledButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            posts.removeAt(index);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Excluir"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            : null,
                      ),
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 8),
                        child: Divider(),
                      ),
                      itemCount: posts.length,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

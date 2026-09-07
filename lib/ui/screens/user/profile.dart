import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/notifiers/post_provider.dart';
import 'package:flutter_project/notifiers/prefs_provider.dart';
import 'package:flutter_project/notifiers/user_posts_provider.dart';
import 'package:flutter_project/repositories/auth_repository.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/repositories/user_repository.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:flutter_project/ui/components/show_delete_post_dialog.dart';
import 'package:flutter_project/ui/components/show_logout_popup.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_project/utils/navigation_utils.dart';
import 'package:flutter_project/utils/posts_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? login;

  const ProfileScreen({this.login, super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late Future<UserResponse> user;

  bool following = false;
  int followingNumber = 0;

  @override
  void initState() {
    super.initState();

    final authRepo = ref.read(authRepositoryProvider);
    final usersRepo = ref.read(usersRepositoryProvider);
    final preferences = ref.read(prefsProvider);

    final preferencesLogin = preferences.getLogin();

    if (!isOwnProfile()) {
      user = usersRepo.getUser(widget.login!);
    } else {
      user = authRepo.getMyProfile();
    }

    user.then((value) {
      if (!mounted) return;

      setState(() {
        following = value.youFollow as bool;
        followingNumber = value.followingNumber ?? 0;
      });
    });
  }

  bool isOwnProfile() {
    final preferences = ref.read(prefsProvider);
    final preferencesLogin = preferences.getLogin();

    return widget.login == null || widget.login == preferencesLogin;
  }

  void changeFollowingState() {
    setState(() {
      if (following) {
        followingNumber--;
      } else {
        followingNumber++;
      }
      following = !following;
    });
  }

  Future<void> followUser(String loginUserToFollow) async {
    final usersRepo = ref.read(usersRepositoryProvider);

    try {
      await usersRepo.followUser(loginUserToFollow);

      if (mounted) {
        showMessage(context, "Você seguiu @$loginUserToFollow!");
        changeFollowingState();
      }

      ref.invalidate(postProvider);
    } catch (e) {
      if (mounted) {
        showMessage(
          context,
          "Erro ao tentar seguir @$loginUserToFollow.",
          isError: true,
        );
      }
    }
  }

  Future<void> unfollowUser(String loginUserToFollow) async {
    final usersRepo = ref.read(usersRepositoryProvider);

    try {
      await usersRepo.unfollowUser(loginUserToFollow);

      if (mounted) {
        showMessage(context, "Você deixou de seguir @$loginUserToFollow");
        changeFollowingState();
      }

      ref.invalidate(postProvider);
    } catch (err) {
      if (mounted) {
        showMessage(
          context,
          "Erro ao tentar deixar de seguir @$loginUserToFollow",
          isError: true,
        );
      }
    }
  }

  void onEditTap() {
    context.push("/edit-profile");
  }

  Future<void> onLogout() async {
    final authRepo = ref.read(authRepositoryProvider);
    final prefsService = ref.read(prefsProvider);

    try {
      await authRepo.logout();
      await prefsService.clearAuth();
      context.replace("/auth");
      Navigator.of(context).pop();
    } catch (e) {
      showMessage(context, "Ocorreu um erro ao deslogar", isError: true);
    }
  }

  Future<void> onDeletePost(PostResponse post, String login) async {
    final postRepo = ref.read(postRepositoryProvider);

    try {
      await postRepo.deletePost(post.id);
      ref.invalidate(postProvider);
      ref.invalidate(myPostsProvider(login));

      if (context.mounted) {
        Navigator.of(context).pop();
        showMessage(context, "Post excluído com sucesso");
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        showMessage(context, "Erro ao tentar excluir post", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? IconButton(
                onPressed: () => NavigationUtils.onGoingBack(context),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(
          isOwnProfile() ? "Meu perfil" : "Perfil de ${widget.login}",
        ),
        actions: [
          if (isOwnProfile())
            IconButton(onPressed: onEditTap, icon: const Icon(Icons.edit)),
          if (isOwnProfile())
            IconButton(
              onPressed: () => onLogoutButton(context, onLogout),
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: FutureBuilder<UserResponse>(
        future: user,
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

          final posts = ref.watch(myPostsProvider(user.login));

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (user.profileImage != null)
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              user.profileImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 64);
                              },
                            ),
                          ),
                        ),

                      if (user.profileImage != null) const SizedBox(height: 8),

                      Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20),
                      ),

                      Text(
                        "@${user.login}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),

                      const SizedBox(height: 16),

                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Seguindo",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                ),
                                Text(
                                  (followingNumber).toString(),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
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
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      if (widget.login != null) ...[
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () async {
                            if (following) {
                              await unfollowUser(user.login);
                            } else {
                              await followUser(user.login);
                            }
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
                      ],

                      const SizedBox(height: 16),

                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              posts.when(
                loading: () {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },

                error: (error, stackTrace) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("Erro: $error"),
                      ),
                    ),
                  );
                },

                data: (data) {
                  if (data.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Nenhum post encontrado"),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverList.separated(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final post = data[index];

                        return InkWell(
                          onTap: () => PostsUtils.onPostTap(context, post),
                          child: Post(
                            postResponse: post,
                            showParentPost: true,
                            maxLines: 5,
                            onDelete: widget.login == null
                                ? () {
                                    showDeletePostDialog(
                                      context,
                                      post,
                                      () async => onDeletePost(post, user.login),
                                    );
                                  }
                                : null,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Divider(),
                        );
                      },
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

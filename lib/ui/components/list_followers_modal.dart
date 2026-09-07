import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/repositories/user_repository.dart';
import 'package:flutter_project/ui/components/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void listFollowersModal(BuildContext context, WidgetRef ref, String login) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return _ListFollowersModalContent(login: login);
    },
  );
}

class _ListFollowersModalContent extends ConsumerStatefulWidget {
  final String login;
  const _ListFollowersModalContent({required this.login});

  @override
  ConsumerState<_ListFollowersModalContent> createState() =>
      _ListFollowersModalContentState();
}

class _ListFollowersModalContentState
    extends ConsumerState<_ListFollowersModalContent> {
  late Future<List<UserResponse>> _followersFuture;

  @override
  void initState() {
    super.initState();
    _followersFuture =
        ref.read(usersRepositoryProvider).listFollowers(widget.login);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Seguidores de ${widget.login}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<UserResponse>>(
              future: _followersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar seguidores.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                final followers = snapshot.data;

                if (followers == null || followers.isEmpty) {
                  return const Center(
                    child: Text("Este usuário ainda não tem seguidores."),
                  );
                }

                return ListView.separated(
                  itemCount: followers.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final userResponse = followers[index];
                    return InkWell(
                      onTap: () {
                        context.pop();
                        context.push("/profile", extra: userResponse.login);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: User(userResponse: userResponse),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
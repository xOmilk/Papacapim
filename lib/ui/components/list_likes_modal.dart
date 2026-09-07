import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/ui/components/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void listLikesModal(BuildContext context, WidgetRef ref, int postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return _ListLikesModalContent(postId: postId);
    },
  );
}

class _ListLikesModalContent extends ConsumerStatefulWidget {
  final int postId;
  const _ListLikesModalContent({required this.postId});

  @override
  ConsumerState<_ListLikesModalContent> createState() =>
      _ListLikesModalContentState();
}

class _ListLikesModalContentState
    extends ConsumerState<_ListLikesModalContent> {
  late Future<List<UserResponse>> _likesFuture;

  @override
  void initState() {
    super.initState();
    _likesFuture = ref.read(postRepositoryProvider).listLikes(widget.postId);
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
                "Curtidas",
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
              future: _likesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar curtidas.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                final likes = snapshot.data;

                if (likes == null || likes.isEmpty) {
                  return const Center(
                    child: Text("Este post ainda não tem curtidas."),
                  );
                }

                return ListView.separated(
                  itemCount: likes.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final userResponse = likes[index];
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


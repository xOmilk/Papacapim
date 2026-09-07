import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/repositories/user_repository.dart';
import 'package:flutter_project/ui/components/post.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_project/ui/components/user.dart';
import 'package:flutter_project/utils/posts_utils.dart';
import 'package:flutter_project/utils/user_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchControl = TextEditingController();

  List<PostResponse>? searchPosts;
  List<UserResponse>? searchUsers;

  bool isSearchLoading = false;

  bool isSearchingPosts = true;

  void changeSearchingState() {
    setState(() {
      isSearchingPosts = !isSearchingPosts;
    });
  }

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    searchControl.dispose();
    super.dispose();
  }

  void onSearchInput(TextEditingController searchInput) {
    if (searchInput.text.trim().isEmpty) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final usersRepo = ref.read(usersRepositoryProvider);
      final postsRepo = ref.read(postRepositoryProvider);

      setState(() {
        isSearchLoading = true;
      });
      try {
        if (isSearchingPosts) {
          final posts = await postsRepo.getPosts(search: searchInput.text);
          setState(() {
            searchPosts = posts;
          });
        } else {
          final users = await usersRepo.listUsers(search: searchInput.text);
          setState(() {
            searchUsers = users;
          });
        }
      } catch (e) {
        if (mounted) {
          showMessage(context, "message", isError: true);
        }
      } finally {
        if (mounted) {
          setState(() {
            isSearchLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(value: false, label: Text('Usuários')),
                  ButtonSegment<bool>(value: true, label: Text('Posts')),
                ],
                selected: {isSearchingPosts},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    isSearchingPosts = newSelection.first;
                  });
                  //busca automaticamente ao trocar de aba
                  onSearchInput(searchControl);
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: searchControl,
              onChanged: (value) => onSearchInput(searchControl),
              decoration: InputDecoration(
                filled: true,
                hintText: "Buscar...",
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: isSearchLoading
                  ? Center(child: CircularProgressIndicator())
                  : isSearchingPosts
                  //caso esteja procurando posts
                  ? ListView.separated(
                      itemCount: searchPosts?.length ?? 0,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () =>
                            PostsUtils.onPostTap(context, searchPosts![index]),
                        child: Post(
                          postResponse: searchPosts![index],
                          maxLines: 3,
                        ),
                      ),
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Divider(),
                      ),
                    )
                  //caso esteja procurando usuarios
                  : ListView.separated(
                      itemCount: searchUsers?.length ?? 0,
                      itemBuilder: (context, index) => InkWell(
                        child: User(userResponse: searchUsers![index]),
                        onTap: () => {
                          UsersUtils.onPostTap(context, searchUsers![index]),
                        },
                      ),
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Divider(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

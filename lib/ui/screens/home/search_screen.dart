import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/repositories/user_repository.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchControl = TextEditingController();

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

  onSearchInput(TextEditingController searchInput) {
    if (searchInput.text.trim().isEmpty) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final usersRepo = ref.read(usersRepositoryProvider);
      final postsRepo = ref.read(postRepositoryProvider);
      try {
        if (isSearchingPosts) {
          final posts = await postsRepo.getPosts(search: searchInput.text);
        } else {
          final users = await usersRepo.listUsers(search: searchInput.text);
        }
      } catch (e) {
        if (mounted) {
          showMessage(context, "message", isError: true);
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
                  // Dispara a busca automaticamente ao trocar de aba
                  onSearchInput(searchControl);
                },
              ),
            ),
            SizedBox(
              height: 16,
            ), // Espaçamento entre os botões e o campo de texto
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
          ],
        ),
      ),
    );
  }
}

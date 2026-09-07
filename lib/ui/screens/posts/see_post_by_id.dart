import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/ui/screens/posts/see_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeePostById extends ConsumerStatefulWidget {
  final int postId;
  const SeePostById({super.key, required this.postId});

  @override
  ConsumerState<SeePostById> createState() => _SeePostByIdState();
}

class _SeePostByIdState extends ConsumerState<SeePostById> {
  late Future<PostResponse> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = ref.read(postRepositoryProvider).getPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostResponse>(
      future: _postFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Post")),
            body: Center(child: Text("Erro ao carregar post: ${snapshot.error}")),
          );
        } else if (snapshot.hasData) {
          return SeePost(post: snapshot.data!);
        } else {
          return const Scaffold(
            body: Center(child: Text("Post não encontrado.")),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_project/models/requests/create_post_request.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void onGoingBack() {
    context.pop();
  }

  void onPublish() async {
    final message = _messageController.text;
    if (message.trim().isNotEmpty) {
      final postRepo = ref.read(postRepositoryProvider);

      try {
        final postRequest = CreatePostRequest(message: message);

        final postResponse = await postRepo.createNewPost(postRequest);
        print(postResponse.toString());
        if (mounted) {
          showMessage(context, "Post Criado com sucesso");
          context.go("/profile");
        }
      } catch (e) {
        if (mounted) {
          showMessage(
            context,
            "Erro ao tentar criar o post, tente novamente.",
            isError: true,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? IconButton(onPressed: onGoingBack, icon: const Icon(Icons.close))
            : null,
        title: const Text("Criar post"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: onPublish,
              child: const Text("Publicar"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  maxLines: null,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "O que você está pensando?",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

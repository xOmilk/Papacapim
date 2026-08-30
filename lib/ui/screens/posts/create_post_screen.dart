import 'package:flutter/material.dart';
import 'package:flutter_project/models/requests/create_post_request.dart';
import 'package:flutter_project/notifiers/post_provider.dart';
import 'package:flutter_project/notifiers/user_posts_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void onGoingBack() {
    context.pop();
  }

  void onPublish() async {
    if (!_formKey.currentState!.validate()) {
      showMessage(context, "Post vazio", isError: true);
      return;
    }

    final postRequest = CreatePostRequest(message: _messageController.text);
    final postRepo = ref.read(postRepositoryProvider);

    setState(() {
      loading = true;
    });

    try {
      await postRepo.createNewPost(postRequest);
      ref.invalidate(postProvider);
      ref.invalidate(myPostsProvider);

      if (mounted) {
        showMessage(context, "Post Criado com sucesso");
        _messageController.clear();
        context.replace("/my-profile");
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          context,
          "Erro ao tentar criar o post, tente novamente.",
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Post vazio";
                    return null;
                  },
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

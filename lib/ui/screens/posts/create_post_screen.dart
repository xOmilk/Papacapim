import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:go_router/go_router.dart';

PostResponse? globalMockNewPost;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void onGoingBack() {
    context.pop();
  }

  void onPublish() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      final mockPost = PostResponse(
        id: DateTime.now().millisecondsSinceEpoch,
        message: message,
        createdAt: DateTime.now(),
        likesNumber: 0,
        repliesNumber: 0,
        youLiked: false,
        user: const UserResponse(
          login: "me",
          name: "Eu Mesmo",
          profileImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiQYULA2iPnmbaEcFvMp2JHp-8efHVSDnCDCHnPIK9UQ&s=10",
        ),
      );
      globalMockNewPost = mockPost;
      context.replace("/my-profile");
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
            child: FilledButton(
              style: ButtonStyle(),
              onPressed: onPublish,
              child: const Text("Publicar"),
            ),
          )
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

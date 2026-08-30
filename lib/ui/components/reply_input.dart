import 'package:flutter_project/notifiers/reply_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/requests/reply_post_request.dart';
import 'package:flutter_project/repositories/post_repository.dart';
import 'package:flutter_project/ui/components/show_message.dart';

class ReplyInput extends ConsumerStatefulWidget {
  final int postId;

  const ReplyInput({required this.postId, super.key});

  @override
  ConsumerState<ReplyInput> createState() => _ReplyInputState();
}

class _ReplyInputState extends ConsumerState<ReplyInput> {
  final _formKey = GlobalKey<FormState>();
  final _replyController = TextEditingController();
  bool loading = false;

  Future<void> onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      showMessage(context, "Comentário vazio", isError: true);
      return;
    }

    final replyRequest = ReplyPostRequest(message: _replyController.text);
    final postRepository = ref.read(postRepositoryProvider);

    setState(() {
      loading = true;
    });

    try {
      await postRepository.createNewReply(widget.postId, replyRequest);
      ref.invalidate(repliesProvider(widget.postId));
    } catch (e) {
      showMessage(context, "Ocorreu um erro", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _replyController,
        validator: (value) {
          if (value == null || value.isEmpty) return "Comentário vazio";
          return null;
        },
        decoration: InputDecoration(
          hintText: "Adicione um comentário...",
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          suffixIcon: loading
              ? Icon(Icons.hourglass_full)
              : IconButton(onPressed: onSubmit, icon: Icon(Icons.send)),
        ),
      ),
    );
  }
}

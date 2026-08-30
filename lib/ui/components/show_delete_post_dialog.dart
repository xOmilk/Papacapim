import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';

void showDeletePostDialog(
  BuildContext context,
  PostResponse post,
  Future<void> Function() onDeletePost,
) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text("Excluir post?"),
      content: const Text("Tem certeza que deseja excluir este post?"),
      actions: [
        TextButton(
          style: const ButtonStyle(
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
          ),
          onPressed: () {
            Navigator.of(dialogContext).pop();
          },
          child: Text(
            "Cancelar",
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.error,
            ),
          ),
          onPressed: onDeletePost,
          child: const Text("Excluir"),
        ),
      ],
    ),
  );
}

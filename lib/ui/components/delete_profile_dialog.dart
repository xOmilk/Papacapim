import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void deleteProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Excluir conta?"),
      content: const Text("Tem certeza que deseja excluir esta conta?"),
      actions: [
        TextButton(
          style: const ButtonStyle(
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
          ),
          onPressed: () {
            Navigator.of(context).pop();
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
          onPressed: () {
            Navigator.of(context).pop();
            context.replace("/auth");
          },
          child: const Text("Excluir"),
        ),
      ],
    ),
  );
}

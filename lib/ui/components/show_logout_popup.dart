import 'package:flutter/material.dart';

void onLogoutButton(BuildContext context, void Function() onLogout) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Sair da conta?"),
      content: const Text("Você tem certeza que deseja sair da sua conta"),
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
          onPressed: onLogout,
          child: const Text("Sair"),
        ),
      ],
    ),
  );
}

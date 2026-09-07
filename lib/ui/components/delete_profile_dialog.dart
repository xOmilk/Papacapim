import 'package:flutter/material.dart';
import 'package:flutter_project/repositories/user_repository.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void deleteProfileDialog(WidgetRef ref, BuildContext context) {
  void onSubmit() async {
    final usersRepo = ref.read(usersRepositoryProvider);

    try {
      await usersRepo.deleteUser();
      Navigator.of(context).pop();
      context.replace("/auth");
    } catch (e) {
      showMessage(context, "Erro ao excluir a conta.", isError: true);
    }
  }

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
          onPressed: onSubmit,
          child: const Text("Excluir"),
        ),
      ],
    ),
  );
}

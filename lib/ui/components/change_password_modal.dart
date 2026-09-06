import 'package:flutter/material.dart';
import 'package:flutter_project/models/requests/update_user_request.dart';
import 'package:flutter_project/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void changePasswordModal(WidgetRef ref, BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscureNew = true;
  bool obscureConfirm = true;

  void onSubmit() async {
    if (formKey.currentState!.validate()) {
      final newPassword = newPasswordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("As senhas não coincidem.")));
        return;
      }

      final updateUserRequest = UpdateUserRequest(
        password: newPassword,
        passwordConfirmation: confirmPassword,
      );

      final usersRepo = ref.read(usersRepositoryProvider);

      try {
        await usersRepo.updateUser(updateUserRequest);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Senha alterada com sucesso.")));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao alterar a senha.")));
      }

      Navigator.of(context).pop();
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Trocar senha"),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nova senha"),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setStateDialog(() {
                            obscureNew = !obscureNew;
                          });
                        },
                        icon: Icon(
                          obscureNew ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Confirmar senha"),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setStateDialog(() {
                            obscureConfirm = !obscureConfirm;
                          });
                        },
                        icon: Icon(
                          obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text("Cancelar"),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: onSubmit,
                child: Text("Alterar Senha"),
              ),
            ],
          );
        },
      );
    },
  );
}

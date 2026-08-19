import 'package:flutter/material.dart';
import 'package:flutter_project/models/requests/register_request.dart';
import 'package:flutter_project/repositories/auth_repository.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  void onSubmit() async {
    try {
      final authRepo = ref.read(authRepositoryProvider);

      final registerRequestData = RegisterRequest(
        login: _usernameController.text,
        name: _fullnameController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmpasswordController.text,
      );

      await authRepo.register(registerRequestData);

      if (mounted) {
        DefaultTabController.of(context).animateTo(0);
        showMessage(context, "Usuário criado, faça login na plataforma");
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, "Erro ao tentar criar usuario", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text("REGISTRO", style: TextStyle(fontSize: 30))),
                SizedBox(height: 32),

                Text(
                  "Login",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Ex: seu_usuario",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  "Nome",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Ex: Gabriel Silva",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  "Senha",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "*******",
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),

                Text(
                  "Confirme sua senha",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: _confirmpasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "*******",
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24),

                FilledButton(onPressed: onSubmit, child: Text("Registrar")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

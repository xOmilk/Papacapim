import 'package:flutter/material.dart';
import 'package:flutter_project/models/requests/login_request.dart';
import 'package:flutter_project/repositories/auth_repository.dart';
import 'package:flutter_project/services/prefs_service.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var prefs = PrefsService();
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;

  void onObscureToggle() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void onSubmit() async {
    final loginRequest = LoginRequest(
      login: _usernameController.text,
      password: _passwordController.text,
    );

    final authRepo = ref.read(authRepositoryProvider);

    try {
      final response = await authRepo.login(loginRequest);

      print("Token retornado ${response.token}");

      showMessage(context, "Usuário logado com sucesso");

      if (mounted) {
        context.go("/");
      }
    } catch (e) {
      // Se deu erro, avisa o usuário
      if (mounted) {
        showMessage(context, "Erro ao fazer login", isError: true);
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
                Center(child: Text("LOGIN", style: TextStyle(fontSize: 30))),
                SizedBox(height: 32),

                Text(
                  "Usuário",
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
                  "Senha",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Sua senha secreta",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: onObscureToggle,
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: _isObscure,
                ),
                SizedBox(height: 24),

                FilledButton(onPressed: onSubmit, child: Text("Entrar")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

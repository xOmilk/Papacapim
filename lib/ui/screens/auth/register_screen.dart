import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  void onSubmit() {
    DefaultTabController.of(context).animateTo(0);
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
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  obscureText: true,
                ),
                SizedBox(height: 16),

                Text(
                  "Confirme sua senha",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
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

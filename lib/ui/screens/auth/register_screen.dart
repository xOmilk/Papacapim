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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("REGISTRO", style: TextStyle(fontSize: 30)),
                TextField(decoration: InputDecoration(hintText: "Login")),
                TextField(decoration: InputDecoration(hintText: "Nome")),
                TextField(decoration: InputDecoration(hintText: "Senha")),
                TextField(
                  decoration: InputDecoration(hintText: "Confirme sua senha"),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onSubmit,
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

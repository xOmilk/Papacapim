import 'package:flutter/material.dart';
import 'package:flutter_project/services/prefs_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var prefs = PrefsService();

  void onSubmit() {
    context.replace("/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("LOGIN", style: TextStyle(fontSize: 30)),
              TextField(decoration: InputDecoration(hintText: "Login")),
              TextField(decoration: InputDecoration(hintText: "Senha")),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: onSubmit, child: Text("Submit")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

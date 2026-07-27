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
  final _formKey = GlobalKey<FormState>();

  bool _isObscure = true;

  void onObscureToggle() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void onSubmit() {
    context.go("/");
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
                Text("LOGIN", style: TextStyle(fontSize: 30)),
                TextField(decoration: InputDecoration(hintText: "Login")),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Senha",
                    suffixIcon: IconButton(
                      onPressed: onObscureToggle,
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: _isObscure,
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

import 'package:flutter/material.dart';
import 'package:flutter_project/ui/screens/auth/login_screen.dart';
import 'package:flutter_project/ui/screens/auth/register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(children: [LoginScreen(), RegisterScreen()]),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Login"),
            Tab(icon: Icon(Icons.home), text: "Register"),
          ],
        ),
      ),
    );
  }
}

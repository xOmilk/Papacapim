import 'package:flutter/material.dart';
import 'package:flutter_project/ui/components/hello_world.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HelloWorld());
  }
}

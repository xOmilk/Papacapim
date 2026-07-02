import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                filled: true,
                hintText: "Buscar...",
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

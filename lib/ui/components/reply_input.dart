import 'package:flutter/material.dart';

class ReplyInput extends StatefulWidget {
  const ReplyInput({super.key});

  @override
  State<ReplyInput> createState() => _ReplyInputState();
}

class _ReplyInputState extends State<ReplyInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.send)),
      ),
    );
  }
}

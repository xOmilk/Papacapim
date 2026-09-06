import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/user_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class User extends ConsumerStatefulWidget {
  final UserResponse userResponse;

  const User({required this.userResponse, super.key});

  @override
  ConsumerState<User> createState() => _UserState();
}

class _UserState extends ConsumerState<User> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        if (widget.userResponse.profileImage != null)
          CircleAvatar(
            radius: 22.5,
            backgroundImage: NetworkImage(widget.userResponse.profileImage!),
          )
        else
          CircleAvatar(
            radius: 22.5,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 26, color: Colors.grey[600]),
          ),
        Flexible(
          child: Text(
            widget.userResponse.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text("@${widget.userResponse.login}"),
        if (widget.userResponse.youFollow!)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Seguindo",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final double radius;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.radius = 22.5,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(imageFile!),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: radius * 1.15, color: Colors.grey[600]),
      );
    }
  }
}

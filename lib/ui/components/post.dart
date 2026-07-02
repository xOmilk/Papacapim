import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';

class Post extends StatefulWidget {
  final PostResponse postResponse;

  const Post({required this.postResponse, super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(100)),
                child: Image.network(
                  widget.postResponse.user?.profileImage ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 64);
                  },
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.postResponse.user?.name ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          widget.postResponse.message,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                Text(widget.postResponse.repliesNumber.toString()),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up)),
                Text(widget.postResponse.likesNumber.toString()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:go_router/go_router.dart';

class Post extends StatefulWidget {
  final PostResponse postResponse;
  final int? maxLines;

  const Post({required this.postResponse, this.maxLines, super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  void onProfileTap() {
    context.push("/profile/${widget.postResponse.user?.login}");
  }

  void onLikeTap() {
    print("Like");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: Row(
            children: [
              if (widget.postResponse.user?.profileImage != null)
                SizedBox(
                  width: 45,
                  height: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.all(
                      Radius.circular(100),
                    ),
                    child: Image.network(
                      widget.postResponse.user!.profileImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 64);
                      },
                    ),
                  ),
                ),
              if (widget.postResponse.user?.profileImage != null)
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
        ),
        SizedBox(height: 4),
        Text(
          widget.postResponse.message,
          maxLines: widget.maxLines,
          overflow: widget.maxLines == null ? null : TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.message),
                ),
                Text(widget.postResponse.repliesNumber.toString()),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: onLikeTap, icon: Icon(Icons.thumb_up)),
                Text(widget.postResponse.likesNumber.toString()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

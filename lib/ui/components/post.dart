import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:go_router/go_router.dart';

class Post extends StatefulWidget {
  final PostResponse postResponse;

  const Post({required this.postResponse, super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  void onProfileTap() {
    context.push("/profile/${widget.postResponse.user?.login}");
  }

  void onPostTap() {
    print("Post");
  }

  void onLikeTap() {
    print("Like");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPostTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: Row(
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.all(
                      Radius.circular(100),
                    ),
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
                  IconButton(onPressed: onPostTap, icon: Icon(Icons.message)),
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
      ),
    );
  }
}

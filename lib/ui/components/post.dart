import 'package:flutter_project/repositories/like_repository.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_project/utils/format_date.dart';
import 'package:flutter_project/utils/posts_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:go_router/go_router.dart';

class Post extends ConsumerStatefulWidget {
  final PostResponse postResponse;
  final bool showParentPost;
  final int? maxLines;
  final VoidCallback? onDelete;

  const Post({
    required this.postResponse,
    this.showParentPost = false,
    this.maxLines,
    this.onDelete,
    super.key,
  });

  @override
  ConsumerState<Post> createState() => _PostState();
}

class _PostState extends ConsumerState<Post> {
  bool liked = false;
  int likes = 0;

  void onProfileTap() {
    context.push("/profile", extra: widget.postResponse.user?.login);
  }

  void onLikeTap() async {
    final likeRepo = ref.read(likeRepositoryProvider);

    try {
      if (!liked) {
        likeRepo.likePost(widget.postResponse.id).then((_) {
          setState(() {
            liked = true;
            likes++;
          });
        });
      } else {
        likeRepo.dislikePost(widget.postResponse.id).then((_) {
          setState(() {
            liked = false;
            likes--;
          });
        });
      }
    } catch (e) {
      showMessage(context, "Erro ao alterar like", isError: true);
    }
  }

  @override
  void initState() {
    super.initState();
    liked = widget.postResponse.youLiked;
    likes = widget.postResponse.likesNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showParentPost && widget.postResponse.postId != null)
          GestureDetector(
            onTap: () {
              PostsUtils.onPostTapById(context, widget.postResponse.postId!);
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
              child: Row(
                children: [
                  Icon(
                    Icons.reply,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    child: Text(
                      "Respondendo a um post",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: onProfileTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.postResponse.user?.profileImage != null)
                      CircleAvatar(
                        radius: 22.5,
                        backgroundImage: NetworkImage(
                          widget.postResponse.user!.profileImage!,
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 22.5,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 26,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.postResponse.user?.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Theme.of(context).colorScheme.error,
                onPressed: widget.onDelete,
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          widget.postResponse.message,
          maxLines: widget.maxLines,
          overflow: widget.maxLines == null ? null : TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsetsGeometry.directional(top: 8, bottom: 4),
          child: Text(
            formatDate(
              widget.postResponse.createdAt,
              style: DateFormatStyle.shortWithTime,
            ),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
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
                IconButton(
                  onPressed: onLikeTap,
                  icon: Icon(
                    Icons.thumb_up,
                    color: liked
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                  ),
                ),
                Text(likes.toString()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

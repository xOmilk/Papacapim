import 'package:flutter_project/repositories/like_repository.dart';
import 'package:flutter_project/ui/components/show_message.dart';
import 'package:flutter_project/utils/format_date.dart';
import 'package:flutter_project/utils/posts_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/ui/components/user_avatar.dart';
import 'package:flutter_project/models/responses/post_response.dart';
import 'package:flutter_project/ui/components/list_likes_modal.dart';
import 'package:go_router/go_router.dart';

class Post extends ConsumerStatefulWidget {
  final PostResponse postResponse;
  final bool showParentPost;
  final int? maxLines;
  final VoidCallback? onDelete;

  const Post({
    required this.postResponse,
    this.showParentPost = true,
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
  int _currentMediaIndex = 0;

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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                PostsUtils.onPostTapById(context, widget.postResponse.postId!);
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.reply,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Respondendo a um post",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
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
                    UserAvatar(
                      imageUrl: widget.postResponse.user?.profileImage,
                      radius: 22.5,
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

        Builder(
          builder: (context) {
            final media = widget.postResponse.media;

            if (media != null && media.isNotEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PageView.builder(
                        itemCount: media.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentMediaIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            media[index].mediumUrl,
                            fit: BoxFit
                                .contain, 
                          );
                        },
                      ),
                    ),
                  ),
                  // Se houver mais de uma imagem, mostra as bolinhas
                  if (media.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          media.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentMediaIndex
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
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
                  onLongPress: () =>
                      listLikesModal(context, ref, widget.postResponse.id),
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

import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../models/feed_models.dart";
import "../providers/feed_provider.dart";
import "feed_icon_button.dart";
import "feed_image.dart";
import "follow_button.dart";
import "gradient_avatar.dart";
import "post_actions.dart";

class PostCard extends ConsumerStatefulWidget {
  final FeedPost post;

  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _heart = false;

  void _doubleTap() {
    ref.read(feedProvider.notifier).like(widget.post.id);
    setState(() => _heart = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _heart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final channel = post.channel;
    final name = post.authorName;
    final followed = ref.watch(followedProvider);
    final notifier = ref.read(feedProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───── Header: channel, location, follow, more ─────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              GradientAvatar(name: name, size: 38),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (channel != null && channel.verified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            CupertinoIcons.checkmark_seal_fill,
                            size: 14,
                            color: CupertinoColors.systemBlue,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      post.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
              if (channel != null) ...[
                FollowButton(
                  following: followed.contains(channel.handle),
                  onTap: () => ref
                      .read(followedProvider.notifier)
                      .toggle(channel.handle),
                ),
                const SizedBox(width: 8),
              ],
              FeedIconButton(
                icon: CupertinoIcons.ellipsis,
                label: "More",
                onTap: () => confirmHide(context, ref, post.id),
              ),
            ],
          ),
        ),

        // ───── Photo (double tap to like) ─────
        GestureDetector(
          onDoubleTap: _doubleTap,
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FeedImage(urls: post.imageUrls),
                IgnorePointer(
                  child: Center(
                    child: AnimatedScale(
                      scale: _heart ? 1.0 : 0.4,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedOpacity(
                        opacity: _heart ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          CupertinoIcons.heart_fill,
                          size: 96,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ───── Actions ─────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              FeedIconButton(
                icon: post.liked
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                label: "Like",
                color: post.liked ? CupertinoColors.systemRed : null,
                onTap: () => notifier.toggleLike(post.id),
              ),
              const SizedBox(width: 8),
              FeedIconButton(
                icon: CupertinoIcons.chat_bubble,
                label: "Comment",
                onTap: () => openComments(context, post.id),
              ),
              const SizedBox(width: 8),
              FeedIconButton(
                icon: CupertinoIcons.paperplane,
                label: "Share",
                onTap: () => sharePost(context, post),
              ),
              const Spacer(),
              FeedIconButton(
                icon: post.saved
                    ? CupertinoIcons.bookmark_fill
                    : CupertinoIcons.bookmark,
                label: "Save",
                onTap: () => notifier.toggleSave(post.id),
              ),
            ],
          ),
        ),

        // ───── Likes, caption, comments, time ─────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${formatCount(post.likes)} likes",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "$name ",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: post.caption),
                  ],
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => openComments(context, post.id),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  post.comments.isEmpty
                      ? "Add a comment..."
                      : "View all ${post.comments.length} comments",
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                post.timeAgo,
                style: const TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../models/feed_models.dart";
import "../../providers/feed_provider.dart";
import "../../widgets/feed_icon_button.dart";
import "../../widgets/feed_image.dart";
import "../../widgets/gradient_avatar.dart";
import "../../widgets/layout.dart";
import "../../widgets/post_actions.dart";

/// Full-screen vertical pager. Uses photos, not video.
class ReelsTab extends ConsumerWidget {
  const ReelsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedProvider);

    if (posts.isEmpty) {
      return const Center(child: Text("Nothing to show yet."));
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: posts.length,
      itemBuilder: (context, index) => _ReelPage(post: posts[index]),
    );
  }
}

class _ReelPage extends ConsumerWidget {
  final FeedPost post;

  const _ReelPage({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = ref.watch(authorProvider);
    final notifier = ref.read(feedProvider.notifier);
    final bottom = MediaQuery.paddingOf(context).bottom + kTabBarSpace;

    const white = CupertinoColors.white;

    return GestureDetector(
      onDoubleTap: () => notifier.like(post.id),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FeedImage(url: post.imageUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0xB3000000)],
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: bottom + 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FeedIconButton(
                  icon: post.liked
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  label: "Like",
                  color: post.liked ? CupertinoColors.systemRed : null,
                  size: 48,
                  onTap: () => notifier.toggleLike(post.id),
                ),
                Text("${post.likes}",
                    style: const TextStyle(color: white, fontSize: 12)),
                const SizedBox(height: 14),
                FeedIconButton(
                  icon: CupertinoIcons.chat_bubble,
                  label: "Comment",
                  size: 48,
                  onTap: () => openComments(context, post.id),
                ),
                Text("${post.comments.length}",
                    style: const TextStyle(color: white, fontSize: 12)),
                const SizedBox(height: 14),
                FeedIconButton(
                  icon: CupertinoIcons.paperplane,
                  label: "Share",
                  size: 48,
                  onTap: () => sharePost(context, post),
                ),
                const SizedBox(height: 14),
                FeedIconButton(
                  icon: post.saved
                      ? CupertinoIcons.bookmark_fill
                      : CupertinoIcons.bookmark,
                  label: "Save",
                  size: 48,
                  onTap: () => notifier.toggleSave(post.id),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 84,
            bottom: bottom + 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GradientAvatar(name: author, size: 34),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  post.caption,
                  style: const TextStyle(color: white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
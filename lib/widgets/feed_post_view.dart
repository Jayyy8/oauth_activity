import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../models/feed_post.dart";
import "gradient_avatar.dart";

/// Round glass icon button used in the feed.
/// Minimal quality keeps scrolling smooth with many buttons on screen.
class FeedActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const FeedActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      icon: Icon(icon),
      iconColor: color,
      iconSize: 20,
      label: label,
      width: 40,
      height: 40,
      useOwnLayer: true,
      quality: GlassQuality.minimal,
      settings: LiquidGlassSettings(blur: 6),
      onTap: onTap,
    );
  }
}

class FeedPostView extends StatefulWidget {
  final FeedPost post;
  final String author;

  const FeedPostView({super.key, required this.post, required this.author});

  @override
  State<FeedPostView> createState() => _FeedPostViewState();
}

class _FeedPostViewState extends State<FeedPostView> {
  bool _liked = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final int likes = post.likes + (_liked ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───── Header: avatar, author, more ─────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              GradientAvatar(name: widget.author, size: 38),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      post.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
              FeedActionButton(
                icon: CupertinoIcons.ellipsis,
                label: "More",
                onTap: () {},
              ),
            ],
          ),
        ),

        // ───── Image (double tap to like) ─────
        GestureDetector(
          onDoubleTap: () => setState(() => _liked = true),
          child: AspectRatio(
            aspectRatio: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: post.colors,
                ),
              ),
              child: Center(
                child: Icon(
                  post.icon,
                  size: 96,
                  color: CupertinoColors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
        ),

        // ───── Actions ─────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              FeedActionButton(
                icon: _liked
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                label: "Like",
                color: _liked ? CupertinoColors.systemRed : null,
                onTap: () => setState(() => _liked = !_liked),
              ),
              const SizedBox(width: 8),
              FeedActionButton(
                icon: CupertinoIcons.chat_bubble,
                label: "Comment",
                onTap: () {},
              ),
              const SizedBox(width: 8),
              FeedActionButton(
                icon: CupertinoIcons.paperplane,
                label: "Share",
                onTap: () {},
              ),
              const Spacer(),
              FeedActionButton(
                icon: _saved
                    ? CupertinoIcons.bookmark_fill
                    : CupertinoIcons.bookmark,
                label: "Save",
                onTap: () => setState(() => _saved = !_saved),
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
                "$likes likes",
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
                      text: "${widget.author} ",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: post.caption),
                  ],
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                "View all ${post.comments} comments",
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey,
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
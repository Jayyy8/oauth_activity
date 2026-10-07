import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../data/sample_feed.dart";
import "../pages/new_post_page.dart";
import "../pages/story_viewer_page.dart";
import "../providers/feed_provider.dart";
import "gradient_avatar.dart";

class StoriesRow extends ConsumerWidget {
  const StoriesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = ref.watch(authorProvider);
    final seen = ref.watch(seenStoriesProvider);

    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: kStoryTopics.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _StoryItem(
              label: "Your story",
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => const NewPostPage()),
              ),
              avatar: GradientAvatar(
                name: author,
                size: 68,
                ring: false,
                showPlus: true,
              ),
            );
          }

          final topic = kStoryTopics[index - 1];
          return _StoryItem(
            label: topic.label,
            onTap: () => Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (_) => StoryViewerPage(topic: topic),
              ),
            ),
            avatar: GradientAvatar(
              name: topic.label,
              size: 68,
              imageUrl: topic.coverUrl,
              seen: seen.contains(topic.id),
            ),
          );
        },
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final String label;
  final Widget avatar;
  final VoidCallback onTap;

  const _StoryItem({
    required this.label,
    required this.avatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          avatar,
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
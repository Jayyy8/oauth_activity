import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../../providers/feed_provider.dart";
import "../../widgets/feed_skeleton.dart";
import "../../widgets/layout.dart";
import "../../widgets/post_card.dart";
import "../../widgets/stories_row.dart";

class FeedTab extends ConsumerWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(feedLoadingProvider);
    final posts = ref.watch(feedProvider);

    // Shimmering placeholders while the feed loads.
    if (loading) return const FeedSkeleton();

    return ListView(
      // Padding keeps the stories clear of the floating app bar.
      padding: contentInsets(context),
      children: [
        const StoriesRow(),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GlassDivider(),
        ),
        const SizedBox(height: 8),
        if (posts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: Text("No posts left. Tap + to create one.")),
          ),
        for (final post in posts) PostCard(key: ValueKey(post.id), post: post),
      ],
    );
  }
}
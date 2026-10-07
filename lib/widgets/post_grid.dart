import "package:flutter/cupertino.dart";

import "../models/feed_models.dart";
import "../pages/post_detail_page.dart";
import "feed_image.dart";

/// 3-column photo grid. Tapping a photo opens the full post.
class PostGrid extends StatelessWidget {
  final List<FeedPost> posts;
  final bool scrollable;
  final EdgeInsets padding;

  const PostGrid({
    super.key,
    required this.posts,
    this.scrollable = true,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: !scrollable,
      physics: scrollable ? null : const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => PostDetailPage(postId: post.id),
            ),
          ),
          child: FeedImage(url: post.imageUrl),
        );
      },
    );
  }
}
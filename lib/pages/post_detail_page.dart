import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../providers/feed_provider.dart";
import "../widgets/post_card.dart";
import "../widgets/sub_page.dart";

class PostDetailPage extends ConsumerWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedProvider);
    final index = posts.indexWhere((p) => p.id == postId);

    if (index < 0) {
      return const SubPage(
        title: "Post",
        child: Center(child: Text("This post was removed.")),
      );
    }

    return SubPage(
      title: "Post",
      child: ListView(children: [PostCard(post: posts[index])]),
    );
  }
}
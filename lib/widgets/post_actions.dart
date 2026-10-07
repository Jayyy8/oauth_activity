import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../models/feed_models.dart";
import "../pages/comments_page.dart";
import "../providers/feed_provider.dart";

/// Copies the post link to the clipboard and confirms with a dialog.
Future<void> sharePost(BuildContext context, FeedPost post) async {
  await Clipboard.setData(ClipboardData(text: post.imageUrls.first));
  if (!context.mounted) return;

  GlassDialog.show(
    context: context,
    title: "Link copied",
    message: "The post link is in your clipboard.",
    actions: [
      GlassDialogAction(
        label: "OK",
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}

void openComments(BuildContext context, String postId) {
  Navigator.of(context).push(
    CupertinoPageRoute(builder: (_) => CommentsPage(postId: postId)),
  );
}

void confirmHide(BuildContext context, WidgetRef ref, String postId) {
  final notifier = ref.read(feedProvider.notifier);

  GlassDialog.show(
    context: context,
    title: "Hide this post?",
    message: "It will be removed from your feed.",
    actions: [
      GlassDialogAction(
        label: "Cancel",
        onPressed: () => Navigator.of(context).pop(),
      ),
      GlassDialogAction(
        label: "Hide",
        isDestructive: true,
        onPressed: () {
          Navigator.of(context).pop();
          notifier.hide(postId);
        },
      ),
    ],
  );
}
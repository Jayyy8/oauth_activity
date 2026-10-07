import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../providers/feed_provider.dart";
import "../widgets/gradient_avatar.dart";
import "../widgets/message_input_bar.dart";
import "../widgets/sub_page.dart";

class CommentsPage extends ConsumerStatefulWidget {
  final String postId;

  const CommentsPage({super.key, required this.postId});

  @override
  ConsumerState<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    ref.read(feedProvider.notifier).addComment(widget.postId, _controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedProvider);
    final author = ref.watch(authorProvider);
    final index = posts.indexWhere((p) => p.id == widget.postId);

    if (index < 0) {
      return const SubPage(
        title: "Comments",
        child: Center(child: Text("This post was removed.")),
      );
    }

    final comments = posts[index].comments;

    return SubPage(
      title: "Comments",
      child: Column(
        children: [
          Expanded(
            child: comments.isEmpty
                ? const Center(child: Text("No comments yet. Be the first."))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: comments.length,
              itemBuilder: (context, i) {
                final c = comments[i];
                final name = c.author ?? author;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientAvatar(name: name, size: 34, ring: false),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "$name ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: c.text),
                            ],
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          MessageInputBar(
            controller: _controller,
            placeholder: "Add a comment...",
            onSend: _send,
          ),
        ],
      ),
    );
  }
}
import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../models/feed_models.dart";
import "../providers/feed_provider.dart";
import "../widgets/auth_button.dart";
import "../widgets/sub_page.dart";

class NewPostPage extends ConsumerStatefulWidget {
  const NewPostPage({super.key});

  @override
  ConsumerState<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends ConsumerState<NewPostPage> {
  final TextEditingController _caption = TextEditingController();
  final TextEditingController _location = TextEditingController();
  int _category = 0;

  @override
  void dispose() {
    _caption.dispose();
    _location.dispose();
    super.dispose();
  }

  void _share() {
    ref.read(feedProvider.notifier).addPost(
      caption: _caption.text,
      location: _location.text,
      category: FeedCategory.values[_category],
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final segments = [
      for (final c in FeedCategory.values) GlassSegment(label: c.label),
    ];

    return SubPage(
      title: "New post",
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const Text(
            "Topic",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          GlassSegmentedControl(
            segments: segments,
            selectedIndex: _category,
            onSegmentSelected: (i) => setState(() => _category = i),
          ),
          const SizedBox(height: 16),
          GlassTextField(controller: _caption, placeholder: "Write a caption..."),
          const SizedBox(height: 10),
          GlassTextField(controller: _location, placeholder: "Add location"),
          const SizedBox(height: 10),
          const Text(
            "A photo that matches the topic is added automatically.",
            style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 20),
          AuthButton(
            label: "Share",
            icon: CupertinoIcons.paperplane,
            onTap: _share,
          ),
        ],
      ),
    );
  }
}
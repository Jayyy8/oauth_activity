import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../../models/feed_models.dart";
import "../../providers/feed_provider.dart";
import "../../widgets/layout.dart";
import "../../widgets/post_grid.dart";

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  final TextEditingController _query = TextEditingController();
  int _filter = 0; // 0 = All

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedProvider);
    final inset = contentInsets(context);
    final q = _query.text.trim().toLowerCase();

    final segments = [
      const GlassSegment(label: "All"),
      for (final c in FeedCategory.values) GlassSegment(label: c.label),
    ];

    final filtered = posts.where((p) {
      final matchesTopic =
          _filter == 0 || p.category == FeedCategory.values[_filter - 1];
      final matchesText = q.isEmpty ||
          p.caption.toLowerCase().contains(q) ||
          p.location.toLowerCase().contains(q) ||
          p.category.label.toLowerCase().contains(q);
      return matchesTopic && matchesText;
    }).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(12, inset.top, 12, 0),
      child: Column(
        children: [
          GlassTextField(controller: _query, placeholder: "Search posts"),
          const SizedBox(height: 10),
          GlassSegmentedControl(
            segments: segments,
            selectedIndex: _filter,
            onSegmentSelected: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("No posts found."))
                : PostGrid(
              posts: filtered,
              padding: EdgeInsets.only(bottom: inset.bottom),
            ),
          ),
        ],
      ),
    );
  }
}
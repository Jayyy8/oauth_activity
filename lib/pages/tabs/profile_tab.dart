import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../../providers/feed_provider.dart";
import "../../providers/supabase_providers.dart";
import "../../widgets/auth_button.dart";
import "../../widgets/gradient_avatar.dart";
import "../../widgets/layout.dart";
import "../../widgets/logout_dialog.dart";
import "../../widgets/post_grid.dart";
import "../../widgets/user_info_dialog.dart";

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  int _section = 0; // 0 = Posts (yours), 1 = Saved

  @override
  Widget build(BuildContext context) {
    final allPosts = ref.watch(feedProvider);
    final author = ref.watch(authorProvider);
    final user = ref.watch(supabaseProvider).auth.currentUser;
    final following = ref.watch(followedProvider);

    final mine = allPosts.where((p) => p.mine).toList();
    final saved = allPosts.where((p) => p.saved).toList();
    final shown = _section == 0 ? mine : saved;

    return ListView(
      padding: contentInsets(context, horizontal: 16),
      children: [
        Row(
          children: [
            GradientAvatar(name: author, size: 86),
            const SizedBox(width: 24),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(value: "${mine.length}", label: "Posts"),
                  _Stat(value: "${following.length}", label: "Following"),
                  _Stat(value: "${saved.length}", label: "Saved"),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          author,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          "ID: ${user?.id ?? '-'}",
          style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AuthButton(
                label: "Print user",
                outlined: true,
                onTap: () => showCurrentUserDialog(context, ref),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AuthButton(
                label: "Log out",
                onTap: () => confirmLogout(context, ref),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassSegmentedControl(
          segments: const [
            GlassSegment(label: "Posts"),
            GlassSegment(label: "Saved"),
          ],
          selectedIndex: _section,
          onSegmentSelected: (i) => setState(() => _section = i),
        ),
        const SizedBox(height: 12),
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                _section == 0
                    ? "No posts yet. Tap + to share your first one."
                    : "Nothing saved yet. Tap the bookmark on a post.",
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          PostGrid(posts: shown, scrollable: false),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
        ),
      ],
    );
  }
}
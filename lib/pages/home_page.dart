import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../providers/auth_controller.dart";
import "../providers/feed_provider.dart";
import "../widgets/auth_background.dart";
import "../widgets/logout_dialog.dart";
import "new_post_page.dart";
import "tabs/feed_tab.dart";
import "tabs/messages_tab.dart";
import "tabs/profile_tab.dart";
import "tabs/reels_tab.dart";
import "tabs/search_tab.dart";

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;

  static const List<String> _titles = [
    "Instagram",
    "Reels",
    "Messages",
    "Search",
    "Profile",
  ];

  void _newPost() {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (_) => const NewPostPage()),
    );
  }

  void _activity() {
    final posts = ref.read(feedProvider);
    final liked = posts.where((p) => p.liked).length;
    final saved = posts.where((p) => p.saved).length;

    GlassDialog.show(
      context: context,
      title: "Activity",
      message: "You liked $liked posts and saved $saved posts.",
      actions: [
        GlassDialogAction(
          label: "OK",
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _body() {
    switch (selectedIndex) {
      case 0:
        return const FeedTab();
      case 1:
        return const ReelsTab();
      case 2:
        return const MessagesTab();
      case 3:
        return const SearchTab();
      default:
        return const ProfileTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(authControllerProvider.notifier);

    return GlassScaffold(
      background: const AuthBackground(),
      appBar: GlassAppBar(
        actions: [
          GlassButtonGroup.icons(items: [
            GlassButtonGroupItem(
              icon: const Icon(CupertinoIcons.add),
              onTap: _newPost,
            ),
            GlassButtonGroupItem(
              icon: const Icon(CupertinoIcons.heart),
              onTap: _activity,
            ),
            GlassButtonGroupItem.menu(
              icon: const Icon(CupertinoIcons.ellipsis),
              menuItems: [
                GlassMenuItem(
                  icon: const Icon(CupertinoIcons.person),
                  title: "Print current user",
                  onTap: controller.printCurrentUser, // Print current user
                ),
                GlassMenuItem(
                  icon: const Icon(CupertinoIcons.lock),
                  title: "Logout",
                  onTap: () => confirmLogout(context, ref),
                ),
              ],
            ),
          ])
        ],
        title: Text(
          _titles[selectedIndex],
          style: TextStyle(
            fontSize: selectedIndex == 0 ? 24 : 18,
            fontStyle: selectedIndex == 0 ? FontStyle.italic : FontStyle.normal,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomBar: GlassTabBar.bottom(
        tabs: const [
          GlassTab(icon: Icon(CupertinoIcons.home)),
          GlassTab(icon: Icon(CupertinoIcons.play_rectangle)),
          GlassTab(icon: Icon(CupertinoIcons.paperplane)),
          GlassTab(icon: Icon(CupertinoIcons.search)),
          GlassTab(icon: Icon(CupertinoIcons.person_crop_circle)),
        ],
        selectedIndex: selectedIndex,
        onTabSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: _body(),
    );
  }
}
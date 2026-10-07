import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../../providers/chat_provider.dart";
import "../../widgets/gradient_avatar.dart";
import "../../widgets/layout.dart";
import "../chat_page.dart";

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: contentInsets(context, horizontal: 16),
      children: [
        GlassGroupedSection(
          header: const Text("MESSAGES"),
          children: [
            for (final thread in kChatThreads)
              GlassListTile(
                leading: GradientAvatar(name: thread.name, size: 40),
                title: Text(thread.name),
                trailing: GlassListTile.chevron,
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => ChatPage(thread: thread)),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
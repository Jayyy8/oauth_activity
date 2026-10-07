import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../providers/auth_controller.dart";

void confirmLogout(BuildContext context, WidgetRef ref) {
  final controller = ref.read(authControllerProvider.notifier);

  GlassDialog.show(
    context: context,
    title: "Log out?",
    message: "You will need to sign in again.",
    actions: [
      GlassDialogAction(
        label: "Cancel",
        onPressed: () => Navigator.of(context).pop(),
      ),
      GlassDialogAction(
        label: "Log out",
        isDestructive: true,
        onPressed: () {
          Navigator.of(context).pop();
          controller.signOut(); // Sign out
        },
      ),
    ],
  );
}
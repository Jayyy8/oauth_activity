import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../providers/auth_controller.dart";
import "../providers/supabase_providers.dart";

String _formatTime(String? iso) {
  final date = DateTime.tryParse(iso ?? "")?.toLocal();
  if (date == null) return "-";
  String two(int n) => n.toString().padLeft(2, "0");
  return "${date.year}-${two(date.month)}-${two(date.day)} "
      "${two(date.hour)}:${two(date.minute)}";
}

/// "Print current user": prints to the console and shows a glass dialog.
void showCurrentUserDialog(BuildContext context, WidgetRef ref) {
  ref.read(authControllerProvider.notifier).printCurrentUser();

  final user = ref.read(supabaseProvider).auth.currentUser;

  if (user == null) {
    GlassDialog.show(
      context: context,
      title: "Current user",
      message: "Nobody is logged in.",
      actions: [
        GlassDialogAction(
          label: "Close",
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
    return;
  }

  final message = [
    "Email: ${user.email ?? '-'}",
    "User ID: ${user.id}",
    "Login method: ${user.appMetadata['provider'] ?? '-'}",
    "Email confirmed: ${user.emailConfirmedAt != null ? 'Yes' : 'No'}",
    "Created: ${_formatTime(user.createdAt)}",
    "Last sign in: ${_formatTime(user.lastSignInAt)}",
    "Role: ${user.role ?? '-'}",
  ].join("\n");

  GlassDialog.show(
    context: context,
    title: "Current user",
    message: message,
    actions: [
      GlassDialogAction(
        label: "Copy ID",
        onPressed: () {
          Clipboard.setData(ClipboardData(text: user.id));
          Navigator.of(context).pop();
        },
      ),
      GlassDialogAction(
        label: "Close",
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}
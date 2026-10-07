import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../providers/auth_controller.dart";

/// A glass card holding a short message (text only, no buttons inside).
class AuthNotice extends StatelessWidget {
  final String message;
  final bool isError;

  const AuthNotice({super.key, required this.message, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isError
                  ? CupertinoColors.destructiveRed
                  : CupertinoColors.activeGreen,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the loading / success / error state from the controller.
class AuthMessage extends ConsumerWidget {
  const AuthMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(authControllerProvider);

    if (ui.loading) {
      return const AuthNotice(message: "Please wait...");
    }
    if (ui.message == null) return const SizedBox.shrink();

    return AuthNotice(message: ui.message!, isError: ui.isError);
  }
}
import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../providers/auth_controller.dart";
import "../widgets/auth_button.dart";
import "../widgets/auth_message.dart";
import "../widgets/auth_page.dart";

/// Shown after the recovery code is verified.
class NewPasswordPage extends ConsumerStatefulWidget {
  const NewPasswordPage({super.key});

  @override
  ConsumerState<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends ConsumerState<NewPasswordPage> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  String? _localError;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authControllerProvider.notifier).clear());
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_password.text.length < 6) {
      setState(() => _localError = "Password must be at least 6 characters.");
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _localError = "Passwords do not match.");
      return;
    }
    setState(() => _localError = null);
    await ref
        .read(authControllerProvider.notifier)
        .updatePassword(_password.text);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(authControllerProvider.notifier);
    final loading = ref.watch(authControllerProvider).loading;

    return AuthPage(
      title: "New password",
      subtitle: "Choose a new password for your account.",
      children: [
        GlassPasswordField(controller: _password),
        const SizedBox(height: 10),
        GlassPasswordField(controller: _confirm),
        const SizedBox(height: 16),
        AuthButton(
          label: "Update password",
          icon: CupertinoIcons.lock_rotation,
          onTap: loading ? null : _save,
        ),
        const SizedBox(height: 10),
        AuthButton(
          label: "Cancel",
          outlined: true,
          onTap: loading ? null : () => controller.cancelRecovery(),
        ),
        const SizedBox(height: 16),
        if (_localError != null) ...[
          AuthNotice(message: _localError!, isError: true),
          const SizedBox(height: 10),
        ],
        const AuthMessage(),
      ],
    );
  }
}
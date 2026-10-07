import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../providers/auth_controller.dart";
import "../widgets/auth_button.dart";
import "../widgets/auth_message.dart";
import "../widgets/auth_page.dart";

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _code = TextEditingController();
  String? _localError;
  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authControllerProvider.notifier).clear());
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_password.text != _confirm.text) {
      setState(() => _localError = "Passwords do not match.");
      return;
    }
    setState(() => _localError = null);
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signUp(_email.text, _password.text);
    if (ok && mounted) setState(() => _codeSent = true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(authControllerProvider.notifier);
    final loading = ref.watch(authControllerProvider).loading;

    return AuthPage(
      title: "Register",
      subtitle: _codeSent ? "Enter the code we emailed you." : null,
      showBack: true,
      children: [
        GlassTextField(controller: _email, placeholder: "Email"),
        const SizedBox(height: 10),
        GlassPasswordField(controller: _password),
        const SizedBox(height: 10),
        GlassPasswordField(controller: _confirm),
        const SizedBox(height: 16),
        if (_codeSent) ...[
          GlassTextField(controller: _code, placeholder: "8-digit code"),
          const SizedBox(height: 16),
          AuthButton(
            label: "Verify email",
            icon: CupertinoIcons.checkmark_shield,
            onTap: loading
                ? null
                : () => controller.verifySignupCode(_email.text, _code.text),
          ),
          const SizedBox(height: 10),
          AuthButton(
            label: "Resend code",
            outlined: true,
            onTap: loading
                ? null
                : () => controller.resendSignupCode(_email.text),
          ),
        ] else
          AuthButton(
            label: "Register",
            icon: CupertinoIcons.person_add,
            onTap: loading ? null : _register,
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
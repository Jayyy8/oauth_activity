import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../providers/auth_controller.dart";
import "../widgets/auth_button.dart";
import "../widgets/auth_message.dart";
import "../widgets/auth_page.dart";

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _code = TextEditingController();
  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authControllerProvider.notifier).clear());
  }

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final ok =
    await ref.read(authControllerProvider.notifier).sendOtp(_email.text);
    if (ok && mounted) setState(() => _codeSent = true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(authControllerProvider.notifier);
    final loading = ref.watch(authControllerProvider).loading;

    return AuthPage(
      title: "OTP Login",
      showBack: true,
      children: [
        GlassTextField(controller: _email, placeholder: "Email"),
        const SizedBox(height: 10),
        if (_codeSent) ...[
          GlassTextField(controller: _code, placeholder: "8-digit code"),
          const SizedBox(height: 16),
          AuthButton(
            label: "Verify code",
            icon: CupertinoIcons.checkmark_shield,
            onTap: loading
                ? null
                : () => controller.verifyOtp(_email.text, _code.text),
          ),
          const SizedBox(height: 10),
        ],
        AuthButton(
          label: _codeSent ? "Resend code" : "Send code",
          icon: CupertinoIcons.paperplane,
          onTap: loading ? null : _sendCode,
        ),
        const SizedBox(height: 16),
        const AuthMessage(),
      ],
    );
  }
}
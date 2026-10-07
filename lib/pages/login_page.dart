import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../providers/auth_controller.dart";
import "../widgets/auth_button.dart";
import "../widgets/auth_message.dart";
import "otp_page.dart";
import "register_page.dart";
import "reset_password_page.dart";

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authControllerProvider.notifier).clear());
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _push(Widget page) {
    ref.read(authControllerProvider.notifier).clear();
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(authControllerProvider.notifier);
    final loading = ref.watch(authControllerProvider).loading;

    return GlassScaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ───── TOP: language, logo, form ─────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            "English (US)",
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: ShaderMask(
                            shaderCallback: (rect) => const LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color(0xFFFFB000),
                                Color(0xFFFF2D55),
                                Color(0xFF8E2DE2),
                              ],
                            ).createShader(rect),
                            child: const Icon(
                              CupertinoIcons.camera,
                              size: 80,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        GlassTextField(
                          controller: _email,
                          placeholder: "Email",
                        ),
                        const SizedBox(height: 14),
                        GlassPasswordField(controller: _password),
                        const SizedBox(height: 14),
                        AuthButton(
                          label: "Log in",
                          onTap: loading
                              ? null
                              : () => controller.signInWithPassword(
                            _email.text,
                            _password.text,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            width: 190,
                            child: AuthButton(
                              label: "Forgot password?",
                              outlined: true,
                              height: 38,
                              onTap: () => _push(const ResetPasswordPage()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const OrDivider(),
                        const SizedBox(height: 16),
                        AuthButton(
                          label: "Log in with OTP",
                          icon: CupertinoIcons.number,
                          outlined: true,
                          onTap: loading ? null : () => _push(const OtpPage()),
                        ),
                        const SizedBox(height: 12),
                        AuthButton(
                          label: "Log in with Apple",
                          icon: CupertinoIcons.person_crop_circle,
                          outlined: true,
                          onTap: loading
                              ? null
                              : () => controller.signInWithApple(),
                        ),
                        const SizedBox(height: 16),
                        const Center(child: AuthMessage()),
                      ],
                    ),

                    // ───── BOTTOM: create account ─────
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: AuthButton(
                        label: "Create new account",
                        outlined: true,
                        onTap:
                        loading ? null : () => _push(const RegisterPage()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "auth_background.dart";
import "auth_widgets.dart";

/// Shared layout for Register, OTP, Forgot password and New password pages.
class AuthPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool showBack;

  /// Zero-based step for the progress dots (null = no dots).
  final int? step;
  final int steps;

  const AuthPage({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
    this.showBack = false,
    this.step,
    this.steps = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      background: const AuthBackground(),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    if (showBack)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GlassButton(
                          icon: const Icon(CupertinoIcons.arrow_left),
                          label: "Back",
                          width: 44,
                          height: 44,
                          iconSize: 20,
                          useOwnLayer: true,
                          settings: LiquidGlassSettings(blur: 8),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      )
                    else
                      const SizedBox(height: 44),
                    const SizedBox(height: 16),
                    AuthHeader(icon: icon, title: title, subtitle: subtitle),
                    if (step != null) ...[
                      const SizedBox(height: 18),
                      Center(child: StepDots(current: step!, total: steps)),
                    ],
                    const SizedBox(height: 28),
                    ...children,
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
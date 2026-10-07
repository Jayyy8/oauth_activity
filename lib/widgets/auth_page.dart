import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

/// Layout for inner pages (Register, OTP, Reset): back arrow, title, subtitle.
class AuthPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool showBack;

  const AuthPage({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              if (showBack)
                GlassButton(
                  icon: const Icon(CupertinoIcons.arrow_left),
                  label: "Back",
                  width: 44,
                  height: 44,
                  iconSize: 20,
                  useOwnLayer: true,
                  settings: LiquidGlassSettings(blur: 8),
                  onTap: () => Navigator.of(context).pop(),
                ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!, style: const TextStyle(fontSize: 16)),
              ],
              const SizedBox(height: 20),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
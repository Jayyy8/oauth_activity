import "package:flutter/cupertino.dart";

/// Gradient behind the glass so the glass widgets have something to refract.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0B0F2A), Color(0xFF1B1040), Color(0xFF3A0F3F)]
              : const [Color(0xFFDDE6FF), Color(0xFFF3E1FF), Color(0xFFFFE3EC)],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}
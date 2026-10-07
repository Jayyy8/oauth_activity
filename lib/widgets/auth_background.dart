import "package:flutter/cupertino.dart";

/// Plain background: black in dark mode, white in light mode.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return ColoredBox(
      color: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      child: const SizedBox.expand(),
    );
  }
}
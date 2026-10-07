import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

/// Small glass "Follow" / "Following" pill for post headers.
class FollowButton extends StatelessWidget {
  final bool following;
  final VoidCallback onTap;

  const FollowButton({super.key, required this.following, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final Color textColor = (!following || isDark)
        ? CupertinoColors.white
        : CupertinoColors.black;
    final String label = following ? "Following" : "Follow";

    return GlassButton.custom(
      label: label,
      onTap: onTap,
      width: 92,
      height: 32,
      shape: const LiquidRoundedRectangle(borderRadius: 16),
      useOwnLayer: true,
      quality: GlassQuality.minimal,
      settings: LiquidGlassSettings(
        glassColor: following
            ? const Color(0x00FFFFFF)
            : const Color(0xB32B3BFF),
        blur: 6,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
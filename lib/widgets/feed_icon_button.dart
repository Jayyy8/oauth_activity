import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

/// Round glass icon button used on posts and reels.
/// Minimal quality keeps scrolling smooth with many buttons on screen.
class FeedIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final double size;

  const FeedIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      icon: Icon(icon),
      iconColor: color,
      iconSize: 20,
      label: label,
      width: size,
      height: size,
      useOwnLayer: true,
      quality: GlassQuality.minimal,
      settings: LiquidGlassSettings(blur: 6),
      onTap: onTap,
    );
  }
}
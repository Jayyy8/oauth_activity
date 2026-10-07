import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

const Color kAuthBlue = Color(0xFF2B3BFF);

/// Pill-shaped glass button.
/// [outlined] = false -> blue-tinted glass (primary action)
/// [outlined] = true  -> clear glass (secondary action)
class AuthButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool outlined;
  final double height;

  const AuthButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.outlined = false,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        CupertinoTheme.brightnessOf(context) == Brightness.dark;

    // Filled blue glass always uses white text.
    // Clear glass uses white in dark mode and black in light mode.
    final Color textColor = (!outlined || isDark)
        ? CupertinoColors.white
        : CupertinoColors.black;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GlassButton.custom(
          label: label,
          onTap: onTap ?? () {},
          enabled: onTap != null,
          width: constraints.maxWidth,
          height: height,
          shape: LiquidRoundedRectangle(borderRadius: height / 2),
          useOwnLayer: true,
          settings: LiquidGlassSettings(
            glassColor: outlined
                ? const Color(0x00FFFFFF)
                : const Color(0xB32B3BFF), // kAuthBlue at about 70%
            blur: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The "OR" separator between the main login and the other login methods.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "OR",
        style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
      ),
    );
  }
}
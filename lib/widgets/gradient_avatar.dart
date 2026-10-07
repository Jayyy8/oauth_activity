import "package:flutter/cupertino.dart";

import "auth_button.dart";
import "feed_image.dart";

/// Round avatar. [ring] draws the Instagram gradient ring (grey when [seen]).
class GradientAvatar extends StatelessWidget {
  final String name;
  final double size;
  final List<String>? imageUrls;
  final bool ring;
  final bool seen;
  final bool showPlus;

  const GradientAvatar({
    super.key,
    required this.name,
    this.size = 40,
    this.imageUrls,
    this.ring = true,
    this.seen = false,
    this.showPlus = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final Color gap = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final Color fill = isDark ? const Color(0xFF2A2A2E) : const Color(0xFFE9E9EE);
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : "?";

    final Widget inner = ClipOval(
      child: SizedBox.expand(
        child: imageUrls != null
            ? FeedImage(urls: imageUrls!)
            : ColoredBox(
          color: fill,
          child: Center(
            child: Text(
              initial,
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );

    final Widget avatar = Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(ring ? 2.5 : 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ring && seen ? const Color(0xFF6E6E73) : null,
        gradient: ring && !seen
            ? const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFFFB000), Color(0xFFFF2D55), Color(0xFF8E2DE2)],
        )
            : null,
      ),
      child: Container(
        padding: EdgeInsets.all(ring ? 2 : 0),
        decoration: BoxDecoration(shape: BoxShape.circle, color: gap),
        child: inner,
      ),
    );

    if (!showPlus) return avatar;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kAuthBlue,
                border: Border.all(color: gap, width: 2),
              ),
              child: Icon(
                CupertinoIcons.add,
                size: size * 0.2,
                color: CupertinoColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import "package:flutter/cupertino.dart";
import "package:skeletonizer/skeletonizer.dart";

import "layout.dart";

/// Shimmer colors that match the current light / dark mode.
ShimmerEffect skeletonEffect(BuildContext context) {
  final bool isDark =
      CupertinoTheme.brightnessOf(context) == Brightness.dark;

  return ShimmerEffect(
    baseColor: isDark ? const Color(0xFF1F1F23) : const Color(0xFFE4E4EA),
    highlightColor: isDark ? const Color(0xFF34343A) : const Color(0xFFF5F5F9),
    duration: const Duration(milliseconds: 1400),
  );
}

/// Placeholder shown instead of the feed while it loads:
/// a stories row and two posts made of shimmering shapes.
class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      effect: skeletonEffect(context),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: contentInsets(context),
        children: const [
          _StoriesSkeleton(),
          SizedBox(height: 16),
          _PostSkeleton(),
          _PostSkeleton(),
        ],
      ),
    );
  }
}

class _StoriesSkeleton extends StatelessWidget {
  const _StoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Bone.circle(size: 68),
              SizedBox(height: 8),
              Bone(width: 56, height: 10),
            ],
          );
        },
      ),
    );
  }
}

class _PostSkeleton extends StatelessWidget {
  const _PostSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: avatar, name, location, buttons
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Bone.circle(size: 38),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone(width: 130, height: 12),
                    SizedBox(height: 6),
                    Bone(width: 90, height: 10),
                  ],
                ),
              ),
              Bone(width: 92, height: 32),
              SizedBox(width: 8),
              Bone.circle(size: 40),
            ],
          ),
        ),

        // Photo
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Bone(width: width, height: width * 1.25);
          },
        ),

        // Action buttons
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Bone.circle(size: 40),
              SizedBox(width: 8),
              Bone.circle(size: 40),
              SizedBox(width: 8),
              Bone.circle(size: 40),
              Spacer(),
              Bone.circle(size: 40),
            ],
          ),
        ),

        // Likes, caption, comments
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone(width: 90, height: 12),
              SizedBox(height: 8),
              Bone(width: 260, height: 12),
              SizedBox(height: 6),
              Bone(width: 180, height: 12),
              SizedBox(height: 8),
              Bone(width: 120, height: 10),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
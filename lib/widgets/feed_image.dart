import "package:flutter/cupertino.dart";

/// Network photo with a placeholder while loading or if it fails.
class FeedImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const FeedImage({super.key, required this.url, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : const _Placeholder(failed: false);
      },
      errorBuilder: (context, error, stackTrace) =>
      const _Placeholder(failed: true),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final bool failed;

  const _Placeholder({required this.failed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B1040), Color(0xFF3A0F3F)],
        ),
      ),
      child: Center(
        child: failed
            ? const Icon(CupertinoIcons.photo, color: Color(0x66FFFFFF), size: 40)
            : const SizedBox.shrink(),
      ),
    );
  }
}
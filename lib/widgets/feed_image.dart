import "package:flutter/cupertino.dart";

/// Network photo that tries each URL in [urls] until one loads,
/// so a failed download falls back instead of leaving a blank.
class FeedImage extends StatefulWidget {
  final List<String> urls;
  final BoxFit fit;

  const FeedImage({super.key, required this.urls, this.fit = BoxFit.cover});

  @override
  State<FeedImage> createState() => _FeedImageState();
}

class _FeedImageState extends State<FeedImage> {
  int _index = 0;

  // Wikimedia asks apps to identify themselves.
  static const Map<String, String> _headers = {
    "User-Agent": "OauthActivityDemo/1.0 (student project)",
  };

  @override
  void didUpdateWidget(covariant FeedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.urls.isEmpty ||
        widget.urls.isEmpty ||
        oldWidget.urls.first != widget.urls.first) {
      _index = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty || _index >= widget.urls.length) {
      return const _Placeholder(failed: true);
    }

    final int current = _index;
    final String url = widget.urls[current];

    return Image.network(
      url,
      key: ValueKey(url),
      headers: _headers,
      fit: widget.fit,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : const _Placeholder(failed: false);
      },
      errorBuilder: (context, error, stackTrace) {
        // Try the next URL after this frame.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _index == current) setState(() => _index++);
        });
        return const _Placeholder(failed: false);
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  final bool failed;

  const _Placeholder({required this.failed});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return ColoredBox(
      color: isDark ? const Color(0xFF1C1C1F) : const Color(0xFFE9E9EE),
      child: Center(
        child: failed
            ? const Icon(
          CupertinoIcons.photo,
          color: CupertinoColors.systemGrey,
          size: 40,
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}
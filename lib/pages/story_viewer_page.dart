import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "../models/feed_models.dart";
import "../providers/feed_provider.dart";
import "../widgets/feed_image.dart";
import "../widgets/gradient_avatar.dart";

/// Full-screen story. Tap right = next, tap left = back, hold = pause.
class StoryViewerPage extends ConsumerStatefulWidget {
  final StoryTopic topic;

  const StoryViewerPage({super.key, required this.topic});

  @override
  ConsumerState<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends ConsumerState<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<String> _photos;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _photos = widget.topic.photos;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addStatusListener(_onStatus)
      ..forward();
    Future.microtask(
          () => ref.read(seenStoriesProvider.notifier).markSeen(widget.topic.id),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _next();
  }

  void _next() {
    if (!mounted) return;
    if (_index < _photos.length - 1) {
      setState(() => _index++);
      _ctrl.forward(from: 0);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _prev() {
    if (_index > 0) setState(() => _index--);
    _ctrl.forward(from: 0);
  }

  Widget _bars() {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Row(
          children: [
            for (int i = 0; i < _photos.length; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                      height: 3,
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: ColoredBox(color: Color(0x59FFFFFF)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: i < _index
                                  ? 1.0
                                  : (i == _index ? _ctrl.value : 0.0),
                              child: const SizedBox(
                                height: 3,
                                child: ColoredBox(color: CupertinoColors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final author = ref.watch(authorProvider);

    return GlassScaffold(
      background: const ColoredBox(color: Color(0xFF000000)),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) {
                final width = MediaQuery.sizeOf(context).width;
                if (details.localPosition.dx < width / 3) {
                  _prev();
                } else {
                  _next();
                }
              },
              onLongPressStart: (_) => _ctrl.stop(),
              onLongPressEnd: (_) => _ctrl.forward(),
              child: FeedImage(key: ValueKey(_index), url: _photos[_index]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _bars(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GradientAvatar(name: author, size: 36, ring: false),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        widget.topic.label,
                        style: const TextStyle(color: Color(0xB3FFFFFF)),
                      ),
                      const SizedBox(width: 10),
                      GlassButton(
                        icon: const Icon(CupertinoIcons.xmark),
                        label: "Close",
                        width: 40,
                        height: 40,
                        iconSize: 18,
                        useOwnLayer: true,
                        settings: LiquidGlassSettings(blur: 8),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
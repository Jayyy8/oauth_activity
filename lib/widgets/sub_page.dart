import "package:flutter/cupertino.dart";
import "package:liquid_glass_widgets/liquid_glass_widgets.dart";

import "auth_background.dart";

/// Glass page with a back button and a title (used for pushed screens).
class SubPage extends StatelessWidget {
  final String title;
  final Widget child;

  const SubPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      background: const AuthBackground(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  GlassButton(
                    icon: const Icon(CupertinoIcons.arrow_left),
                    label: "Back",
                    width: 44,
                    height: 44,
                    iconSize: 20,
                    useOwnLayer: true,
                    settings: LiquidGlassSettings(blur: 8),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
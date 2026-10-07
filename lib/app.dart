import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "pages/auth_gate.dart";
import "providers/theme_provider.dart";

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(themeProvider);

    return CupertinoApp(
      theme: CupertinoThemeData(brightness: brightness),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
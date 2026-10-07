import "package:flutter/cupertino.dart";

import "pages/auth_gate.dart";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.dark, // change to Brightness.light to test
      ),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
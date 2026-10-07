import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Current app brightness. Toggled from the glass menu.
class ThemeNotifier extends Notifier<Brightness> {
  @override
  Brightness build() => Brightness.dark;

  void toggle() {
    state = state == Brightness.dark ? Brightness.light : Brightness.dark;
  }
}

final themeProvider =
NotifierProvider<ThemeNotifier, Brightness>(ThemeNotifier.new);
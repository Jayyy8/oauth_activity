import "package:flutter/cupertino.dart";

/// Space reserved for the floating glass app bar and tab bar.
/// If content still hides behind a bar, raise the matching number.
const double kAppBarSpace = 64;
const double kTabBarSpace = 100;

EdgeInsets contentInsets(BuildContext context, {double horizontal = 0}) {
  final padding = MediaQuery.paddingOf(context);
  return EdgeInsets.fromLTRB(
    horizontal,
    padding.top + kAppBarSpace,
    horizontal,
    padding.bottom + kTabBarSpace,
  );
}
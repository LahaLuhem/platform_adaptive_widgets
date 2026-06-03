import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPageRoute;
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialPageRoute;

/// Pushes [builder]'s screen with the platform's native page transition —
/// Cupertino's swipe-back route on iOS, the Material route on Android.
///
/// The library adapts *widgets*, not routes, so the Navigator entry point
/// supplies this thin platform-adaptive push. (The go_router entry point gets
/// the same effect for free from `PlatformApp.router`'s per-platform routing.)
Future<T?> pushPlatformRoute<T>(BuildContext context, WidgetBuilder builder) {
  final route = switch (defaultTargetPlatform) {
    .iOS => CupertinoPageRoute<T>(builder: builder),
    _ => MaterialPageRoute<T>(builder: builder),
  };

  return Navigator.of(context).push(route);
}

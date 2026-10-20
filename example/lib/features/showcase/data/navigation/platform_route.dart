import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPageRoute;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialPageRoute;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Pushes [builder]'s screen on the platform's own route, so iOS gets swipe-back and Android gets the
/// Material transition.
///
/// Lives here because the library adapts widgets, not routes. The go_router entry point needs none of
/// this, getting the same from `PlatformApp.router`.
Future<T?> pushPlatformRoute<T>(BuildContext context, WidgetBuilder builder) {
  final route = switch (designLanguage) {
    .cupertino => CupertinoPageRoute<T>(builder: builder),
    .material => MaterialPageRoute<T>(builder: builder),
  };

  return Navigator.of(context).push(route);
}

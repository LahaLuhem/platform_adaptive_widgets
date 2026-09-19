import 'package:flutter/widgets.dart';

import '/src/models/platform_widget_base.dart';

/// Builds one thing on Android and a different thing on iOS, when the 2 have nothing in common. Only
/// wrapping the same widget differently? [PlatformWidgetBuilder] is the lighter option.
///
/// Example:
/// {@example /example/lib/snippets/platform_widget.dart#platform_widget}
class const PlatformWidget({
  @protected required final WidgetBuilder materialBuilder,

  @protected required final WidgetBuilder cupertinoBuilder,
  super.key,
}) extends PlatformWidgetBase {
  /// Creates a platform-adaptive widget with a builder for each platform.
  this;

  @override
  Widget buildMaterial(BuildContext context) => materialBuilder(context);

  @override
  Widget buildCupertino(BuildContext context) => cupertinoBuilder(context);
}

/// Hands one [child] to whichever builder the platform calls for, so you can wrap it in different padding,
/// decoration or behaviour without writing the child twice.
///
/// Example:
/// {@example /example/lib/snippets/platform_widget.dart#platform_widget_builder}
class const PlatformWidgetBuilder({
  @protected
  required final Widget Function(BuildContext context, Widget child) materialWidgetBuilder,

  @protected
  required final Widget Function(BuildContext context, Widget child) cupertinoWidgetBuilder,

  /// Goes to whichever builder runs.
  required final Widget child,
  super.key,
}) extends PlatformWidgetBase {
  /// Creates a platform-adaptive wrapper around a [child].
  this;

  @override
  Widget buildMaterial(BuildContext context) => materialWidgetBuilder(context, child);

  @override
  Widget buildCupertino(BuildContext context) => cupertinoWidgetBuilder(context, child);
}

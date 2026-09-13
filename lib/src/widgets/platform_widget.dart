import 'package:flutter/widgets.dart';

import '/src/models/platform_widget_base.dart';

/// A platform-adaptive widget that provides different implementations for Material and Cupertino.
///
/// This widget automatically selects the appropriate builder based on the target platform:
/// - On Android, it uses [materialBuilder]
/// - On iOS, it uses [cupertinoBuilder]
///
/// Use this widget when you need completely different widget implementations for each platform. For
/// simpler cases where you're just adapting properties, consider using [PlatformWidgetBuilder].
///
/// Example:
/// ```dart
/// PlatformWidget(
///   materialBuilder: (_) => ElevatedButton(
///     onPressed: () {},
///     child: Text('Android Button'),
///   ),
///   cupertinoBuilder: (_) => CupertinoButton(
///     onPressed: () {},
///     child: Text('iOS Button'),
///   ),
/// )
/// ```
class const PlatformWidget({
  /// Builder function for the Material Design (Android) implementation.
  ///
  /// This function is called when the app is running on Android devices. The returned widget will be
  /// used as the platform-specific implementation.
  @protected required final WidgetBuilder materialBuilder,

  /// Builder function for the Cupertino (iOS) implementation.
  ///
  /// This function is called when the app is running on iOS devices. The returned widget will be used
  /// as the platform-specific implementation.
  @protected required final WidgetBuilder cupertinoBuilder,
  super.key,
}) extends PlatformWidgetBase {
  /// Creates a platform-adaptive widget with separate builders for each platform.
  ///
  /// [materialBuilder] and [cupertinoBuilder] are required and must not be null. Both builders are
  /// eagerly evaluated when the widget is built.
  this;

  @override
  Widget buildMaterial(BuildContext context) => materialBuilder(context);

  @override
  Widget buildCupertino(BuildContext context) => cupertinoBuilder(context);
}

/// A platform-adaptive widget that wraps a child widget with platform-specific behavior.
///
/// This widget provides a child widget to platform-specific builder functions, allowing you to wrap
/// the child with platform-appropriate styling or behavior.
///
/// This is useful when you want to apply platform-specific decorations, padding, or behavior to an
/// existing widget.
///
/// Example:
/// ```dart
/// PlatformWidgetBuilder(
///   materialWidgetBuilder: (context, child) => Card(child: child),
///   cupertinoWidgetBuilder: (context, child) => CupertinoListTile(title: child),
///   child: Text('Content'),
/// )
/// ```
class const PlatformWidgetBuilder({
  /// Builder function for the Material Design (Android) implementation.
  ///
  /// This function receives the `context` and [child] widget and should return a wrapped version of
  /// the child with Material-specific styling or behavior.
  @protected
  required final Widget Function(BuildContext context, Widget child) materialWidgetBuilder,

  /// Builder function for the Cupertino (iOS) implementation.
  ///
  /// This function receives the `context` and [child] widget and should return a wrapped version of
  /// the child with Cupertino-specific styling or behavior.
  @protected
  required final Widget Function(BuildContext context, Widget child) cupertinoWidgetBuilder,

  /// The child widget to be wrapped with platform-specific behavior.
  ///
  /// This widget is passed to the appropriate builder function based on the platform.
  required final Widget child,
  super.key,
}) extends PlatformWidgetBase {
  /// Creates a platform-adaptive builder widget with a required child.
  ///
  /// [materialWidgetBuilder] and [cupertinoWidgetBuilder] are required and must not be null. [child]
  /// is also required and will be passed to the appropriate builder.
  this;

  @override
  Widget buildMaterial(BuildContext context) => materialWidgetBuilder(context, child);

  @override
  Widget buildCupertino(BuildContext context) => cupertinoWidgetBuilder(context, child);
}

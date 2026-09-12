// Widgets may need space to compute their layout.
// ignore_for_file: avoid-returning-widgets

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Abstract base class for platform-adaptive widgets.
///
/// Subclasses override [buildMaterial] and [buildCupertino] to provide platform-specific implementations.
/// The [build] method automatically delegates to the correct builder based on [defaultTargetPlatform].
///
/// On Android, [buildMaterial] is called. On iOS, [buildCupertino] is called. Other platforms throw
/// an [UnsupportedError].
@protected
abstract class const PlatformWidgetBase({super.key}) extends StatelessWidget {
  /// Creates a platform-adaptive widget.
  this;

  @override
  @protected
  @nonVirtual
  Widget build(BuildContext context) => switch (defaultTargetPlatform) {
    .android => buildMaterial(context),
    .iOS => buildCupertino(context),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };

  /// Builds the Material Design (Android) variant of this widget.
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context);

  /// Builds the Cupertino (iOS) variant of this widget.
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context);
}

/// A [PlatformWidgetBase] that accepts a separate [widgetKey] for the underlying platform widget,
/// distinct from the outer widget's [key].
abstract class const PlatformWidgetKeyedBase({
  /// Optional key applied to the inner platform-specific widget.
  final Key? widgetKey,
  super.key,
}) extends PlatformWidgetBase {
  /// Creates a keyed platform-adaptive widget.
  this;
}

/// A [PlatformWidgetBase] that wraps a required [child] widget.
abstract class const PlatformWidgetBuilderBase({
  /// The child widget to wrap with platform-specific behavior.
  required final Widget child,
  super.key,
}) extends PlatformWidgetBase {
  /// Creates a platform-adaptive builder widget with a required [child].
  this;
}

/// A [PlatformWidgetBase] that combines both a [widgetKey] and a required [child].
abstract class const PlatformWidgetKeyedBuilderBase({
  /// The child widget to wrap with platform-specific behavior.
  required final Widget child,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a keyed platform-adaptive builder widget with a required [child].
  this;
}

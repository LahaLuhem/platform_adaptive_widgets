// Widgets may need space to compute their layout.
// ignore_for_file: avoid-returning-widgets

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../utils/target_platform.dart';

/// Abstract base class for platform-adaptive widgets.
///
/// Subclasses override [buildMaterial] and [buildCupertino] to provide
/// platform-specific implementations. The [build] method automatically
/// delegates to the correct builder based on [defaultTargetPlatform].
///
/// On Android, [buildMaterial] is called. On iOS, [buildCupertino] is called.
/// Other platforms throw an [UnsupportedError].
@protected
abstract class PlatformWidgetBase extends StatelessWidget {
  /// Creates a platform-adaptive widget.
  const PlatformWidgetBase({super.key});

  @override
  @protected
  @nonVirtual
  Widget build(BuildContext context) => switch (targetPlatform) {
    .android => buildMaterial(context),
    .iOS => buildCupertino(context),
    _ => throw UnsupportedError('This platform is not supported: $targetPlatform'),
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

/// A [PlatformWidgetBase] that accepts a separate [widgetKey] for the
/// underlying platform widget, distinct from the outer widget's [key].
abstract class PlatformWidgetKeyedBase extends PlatformWidgetBase {
  /// Optional key applied to the inner platform-specific widget.
  final Key? widgetKey;

  /// Creates a keyed platform-adaptive widget.
  const PlatformWidgetKeyedBase({this.widgetKey, super.key});
}

/// A [PlatformWidgetBase] that wraps a required [child] widget.
abstract class PlatformWidgetBuilderBase extends PlatformWidgetBase {
  /// The child widget to wrap with platform-specific behavior.
  final Widget child;

  /// Creates a platform-adaptive builder widget with a required [child].
  const PlatformWidgetBuilderBase({required this.child, super.key});
}

/// A [PlatformWidgetBase] that combines both a [widgetKey] and a required [child].
abstract class PlatformWidgetKeyedBuilderBase extends PlatformWidgetKeyedBase {
  /// The child widget to wrap with platform-specific behavior.
  final Widget child;

  /// Creates a keyed platform-adaptive builder widget with a required [child].
  const PlatformWidgetKeyedBuilderBase({required this.child, super.widgetKey, super.key});
}

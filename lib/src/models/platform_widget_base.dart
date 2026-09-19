// Widgets may need space to compute their layout.
// ignore_for_file: avoid-returning-widgets

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Base class for every platform-adaptive widget here.
///
/// Override [buildMaterial] and [buildCupertino], never [build]. That one reads [defaultTargetPlatform]
/// and picks for you, throwing an [UnsupportedError] on anything that isn't Android or iOS.
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

  /// Builds the Android half.
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context);

  /// Builds the iOS half.
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context);
}

/// A [PlatformWidgetBase] whose [widgetKey] goes on the platform widget inside, leaving [key] for the
/// outer one.
abstract class const PlatformWidgetKeyedBase({final Key? widgetKey, super.key})
    extends PlatformWidgetBase {
  /// Creates a keyed platform-adaptive widget.
  this;
}

/// A [PlatformWidgetBase] that wraps a required [child].
abstract class const PlatformWidgetBuilderBase({required final Widget child, super.key})
    extends PlatformWidgetBase {
  /// Creates a platform-adaptive builder widget with a required [child].
  this;
}

/// Both of the above at once.
abstract class const PlatformWidgetKeyedBuilderBase({
  required final Widget child,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a keyed platform-adaptive builder widget with a required [child].
  this;
}

// Widgets may need space to compute their layout.
// ignore_for_file: avoid-returning-widgets

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@protected
/// Core widget with compile-time resolution
abstract class PlatformWidgetBase extends StatelessWidget {
  const PlatformWidgetBase({super.key});

  @override
  @protected
  @nonVirtual
  Widget build(BuildContext context) => switch (defaultTargetPlatform) {
    .android => buildMaterial(context),
    .iOS => buildCupertino(context),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };

  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context);

  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context);
}

abstract class PlatformWidgetKeyedBase extends PlatformWidgetBase {
  final Key? widgetKey;
  const PlatformWidgetKeyedBase({this.widgetKey, super.key});
}

abstract class PlatformWidgetBuilderBase extends PlatformWidgetBase {
  final Widget child;
  const PlatformWidgetBuilderBase({required this.child, super.key});
}

abstract class PlatformWidgetKeyedBuilderBase extends PlatformWidgetKeyedBase {
  final Widget child;
  const PlatformWidgetKeyedBuilderBase({required this.child, super.widgetKey, super.key});
}

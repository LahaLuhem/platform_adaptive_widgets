// Widgets may need space to compute their layout.
// ignore_for_file: avoid-returning-widgets

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Core widget with compile-time resolution
abstract class PlatformWidgetBase extends StatelessWidget {
  const PlatformWidgetBase({super.key});

  @override
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

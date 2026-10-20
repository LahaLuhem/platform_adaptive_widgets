/// @docImport 'platform_progress_bar.dart';
library;

import 'dart:ui' show SemanticsRole;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoActivityIndicator;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show CircularProgressIndicator;

import '/src/models/painting/platform_progress_indicator_data.dart';
import '/src/models/platform_widget_base.dart';

/// A spinner for work with no known end: [CircularProgressIndicator] on Material,
/// [CupertinoActivityIndicator] on Cupertino. For work where you know how far along it is, use
/// [PlatformProgressBar].
///
/// Guidelines: [M3 progress indicators](https://m3.material.io/components/progress-indicators/guidelines),
/// [HIG progress indicators](https://developer.apple.com/design/human-interface-guidelines/progress-indicators#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/painting/platform_progress_indicator.dart#platform_progress_indicator}
class const PlatformProgressIndicator({
  final Color? color,

  /// What's loading, like "Loading inbox"
  /// ([M3 accessibility](https://m3.material.io/components/progress-indicators/accessibility)).
  final String? semanticsLabel,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialProgressIndicatorData? materialProgressIndicatorData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoProgressIndicatorData? cupertinoProgressIndicatorData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive progress indicator.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) => CircularProgressIndicator(
    key: widgetKey,
    color: materialProgressIndicatorData?.color ?? color,
    backgroundColor: materialProgressIndicatorData?.backgroundColor,
    valueColor: materialProgressIndicatorData?.valueColor,
    strokeWidth: materialProgressIndicatorData?.strokeWidth,
    strokeAlign: materialProgressIndicatorData?.strokeAlign,
    semanticsLabel: semanticsLabel,
    strokeCap: materialProgressIndicatorData?.strokeCap,
    constraints: materialProgressIndicatorData?.constraints,
    trackGap: materialProgressIndicatorData?.trackGap,
    padding: materialProgressIndicatorData?.padding,
    controller: materialProgressIndicatorData?.controller,
  );

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) => Semantics(
    // cupertino_ui's spinner has no semantics of its own, so this matches what Material's sets.
    label: semanticsLabel,
    role: SemanticsRole.loadingSpinner,
    child: CupertinoActivityIndicator(
      key: widgetKey,
      color: cupertinoProgressIndicatorData?.color ?? color,
      animating: cupertinoProgressIndicatorData?.animating ?? kDefaultProgressIndicatorAnimating,
      radius: cupertinoProgressIndicatorData?.radius ?? kDefaultProgressIndicatorRadius,
    ),
  );
}

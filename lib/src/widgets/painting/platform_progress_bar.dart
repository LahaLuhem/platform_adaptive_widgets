/// @docImport 'platform_progress_indicator.dart';
library;

import 'dart:ui' show SemanticsRole;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLinearActivityIndicator;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show LinearProgressIndicator;

import '/src/models/painting/platform_progress_bar_data.dart';
import '/src/models/platform_widget_base.dart';

/// Shows how far along a task is, as a bar: [LinearProgressIndicator] on Material,
/// [CupertinoLinearActivityIndicator] on Cupertino. For work with no known end, use [PlatformProgressIndicator].
///
/// A bar on both platforms, since Cupertino draws known progress only as a bar
/// ([HIG](https://developer.apple.com/design/human-interface-guidelines/progress-indicators#Best-practices)).
/// It spans its parent's width, so inside a [Row] it wants an [Expanded].
///
/// Guidelines: [M3 progress indicators](https://m3.material.io/components/progress-indicators/guidelines),
/// [HIG progress indicators](https://developer.apple.com/design/human-interface-guidelines/progress-indicators).
///
/// Example:
/// {@example /example/lib/snippets/painting/platform_progress_bar.dart#platform_progress_bar}
class const PlatformProgressBar({
  /// How far along, from 0 to 1.
  required final double value,

  final Color? color,

  /// What's loading, like "Loading inbox"
  /// ([M3 accessibility](https://m3.material.io/components/progress-indicators/accessibility)).
  final String? semanticsLabel,

  /// Read out instead of the percent, like "3 of 10 files".
  final String? semanticsValue,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialProgressBarData? materialProgressBarData,

  /// Cupertino-branch overrides.
  final CupertinoProgressBarData? cupertinoProgressBarData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive progress bar.
  this : assert(value >= 0 && value <= 1, 'value must be between 0 and 1');

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) => LinearProgressIndicator(
    key: widgetKey,
    value: value,
    color: materialProgressBarData?.color ?? color,
    semanticsLabel: semanticsLabel,
    semanticsValue: semanticsValue,
    backgroundColor: materialProgressBarData?.backgroundColor,
    valueColor: materialProgressBarData?.valueColor,
    borderRadius: materialProgressBarData?.borderRadius,
    stopIndicatorColor: materialProgressBarData?.stopIndicatorColor,
    stopIndicatorRadius: materialProgressBarData?.stopIndicatorRadius,
    trackGap: materialProgressBarData?.trackGap,
  );

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) => Semantics(
    // cupertino_ui's bar has no semantics of its own. Flutter wants the role's 0 to 100 range, but
    // Cupertino doesn't read it out, so the percent goes into the value too.
    label: semanticsLabel,
    value: semanticsValue ?? '${(value * 100).round()}%',
    minValue: '0',
    maxValue: '100',
    role: SemanticsRole.progressBar,
    child: CupertinoLinearActivityIndicator(
      key: widgetKey,
      progress: value,
      color: cupertinoProgressBarData?.color ?? color,
    ),
  );
}

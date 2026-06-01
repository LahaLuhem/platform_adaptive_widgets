import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoActivityIndicator;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show CircularProgressIndicator;

import '/src/models/painting/platform_progress_indicator_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive progress indicator that renders Material
/// [CircularProgressIndicator] on Android and [CupertinoActivityIndicator]
/// on iOS.
///
/// Display-only widget — no callbacks, no value/onChanged at the widget
/// level. Material's value-based progress and animation control live on
/// [MaterialProgressIndicatorData]; Cupertino's animating toggle and radius
/// live on [CupertinoProgressIndicatorData]. The only field shared at the
/// widget level is [color]. See `APPENDIX.md#field-classification`.
///
/// Example:
/// ```dart
/// PlatformProgressIndicator(color: Colors.blue)
/// ```
class PlatformProgressIndicator extends PlatformWidgetKeyedBase {
  /// Color of the progress indicator. Shared visual — overridable per
  /// platform via [materialProgressIndicatorData] / [cupertinoProgressIndicatorData].
  final Color? color;

  /// Material-only configuration. Optional.
  ///
  /// Houses both Material-only visual fields (`backgroundColor`,
  /// `strokeWidth`, etc.) and Material-only functional fields (`value`,
  /// `controller`, `semanticsLabel`, `semanticsValue`) — the latter because
  /// they have no equivalent on Cupertino's activity indicator.
  final MaterialProgressIndicatorData? materialProgressIndicatorData;

  /// Cupertino-only configuration. Optional.
  ///
  /// Houses Cupertino-only fields (`animating`, `radius`).
  final CupertinoProgressIndicatorData? cupertinoProgressIndicatorData;

  /// Creates a platform-adaptive progress indicator.
  const PlatformProgressIndicator({
    this.color,
    this.materialProgressIndicatorData,
    this.cupertinoProgressIndicatorData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => CircularProgressIndicator(
    key: widgetKey,
    color: materialProgressIndicatorData?.color ?? color,
    value: materialProgressIndicatorData?.value,
    backgroundColor: materialProgressIndicatorData?.backgroundColor,
    valueColor: materialProgressIndicatorData?.valueColor,
    strokeWidth: materialProgressIndicatorData?.strokeWidth,
    strokeAlign: materialProgressIndicatorData?.strokeAlign,
    semanticsLabel: materialProgressIndicatorData?.semanticsLabel,
    semanticsValue: materialProgressIndicatorData?.semanticsValue,
    strokeCap: materialProgressIndicatorData?.strokeCap,
    constraints: materialProgressIndicatorData?.constraints,
    trackGap: materialProgressIndicatorData?.trackGap,
    padding: materialProgressIndicatorData?.padding,
    controller: materialProgressIndicatorData?.controller,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoActivityIndicator(
    key: widgetKey,
    color: cupertinoProgressIndicatorData?.color ?? color,
    animating: cupertinoProgressIndicatorData?.animating ?? kDefaultProgressIndicatorAnimating,
    radius: cupertinoProgressIndicatorData?.radius ?? kDefaultProgressIndicatorRadius,
  );
}

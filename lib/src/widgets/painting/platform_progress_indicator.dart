import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoActivityIndicator;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show CircularProgressIndicator;

import '/src/models/painting/platform_progress_indicator_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [CircularProgressIndicator] on Android, [CupertinoActivityIndicator] on iOS.
///
/// Nothing to interact with, so [color] is the only thing flat on the widget. Determinate progress and
/// animation control are Material's alone and live on [MaterialProgressIndicatorData]. See `APPENDIX.md#field-classification`.
///
/// Example:
/// {@example /example/lib/snippets/painting/platform_progress_indicator.dart#platform_progress_indicator}
class const PlatformProgressIndicator({
  final Color? color,

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

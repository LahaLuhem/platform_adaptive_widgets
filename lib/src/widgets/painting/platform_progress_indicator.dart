import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:flutter/widgets.dart';

import '/src/models/painting/platform_progress_indicator_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive progress indicator that renders Material CircularProgressIndicator on Android
/// and CupertinoActivityIndicator on iOS.
///
/// This widget automatically selects the appropriate progress indicator implementation based on the target platform:
/// - On Android: renders Material Design CircularProgressIndicator
/// - On iOS: renders CupertinoActivityIndicator
///
/// The progress indicator can be configured with platform-specific data through [materialProgressIndicatorData]
/// and [cupertinoProgressIndicatorData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformProgressIndicator(
///   color: Colors.blue,
/// )
/// ```
class PlatformProgressIndicator extends PlatformWidgetKeyedBase {
  /// Color of the progress indicator.
  final Color? color;

  /// Material-specific progress indicator data.
  final MaterialProgressIndicatorData? materialProgressIndicatorData;

  /// Cupertino-specific progress indicator data.
  final CupertinoProgressIndicatorData? cupertinoProgressIndicatorData;

  /// Creates a platform-adaptive progress indicator.
  ///
  /// The progress indicator will render as a Material CircularProgressIndicator on Android and a CupertinoActivityIndicator on iOS.
  const PlatformProgressIndicator({
    this.color,
    this.materialProgressIndicatorData,
    this.cupertinoProgressIndicatorData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => CircularProgressIndicator(
    key: materialProgressIndicatorData?.widgetKey ?? widgetKey,
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
    key: cupertinoProgressIndicatorData?.widgetKey ?? widgetKey,
    color: cupertinoProgressIndicatorData?.color ?? color,
    animating:
        cupertinoProgressIndicatorData?.animating ??
        CupertinoProgressIndicatorData.kDefaultAnimating,
    radius:
        cupertinoProgressIndicatorData?.radius ??
        CupertinoProgressIndicatorData.kDefaultIndicatorRadius,
  );
}

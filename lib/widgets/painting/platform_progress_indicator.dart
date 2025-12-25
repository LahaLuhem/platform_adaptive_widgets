import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:flutter/widgets.dart';

import '/models/painting/platform_progress_indicator_data.dart';
import '/models/platform_widget_base.dart';

class PlatformProgressIndicator extends PlatformWidgetKeyedBase {
  final Color? color;

  final MaterialProgressIndicatorData? materialProgressIndicatorData;
  final CupertinoProgressIndicatorData? cupertinoProgressIndicatorData;

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

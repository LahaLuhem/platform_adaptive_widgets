import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoAlertDialog, CupertinoDialogAction, showCupertinoDialog;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show AlertDialog, ButtonTheme, Colors, Dialog, TextButton, showDialog;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import '/src/models/dialogs/platform_dialog_data.dart';
import '/src/models/platform_widget_base.dart';

part 'platform_alert_dialog.dart';

/// Shows a platform-adaptive dialog that renders Material dialogs on Android
/// and Cupertino dialogs on iOS.
///
/// This function automatically selects the appropriate dialog implementation based on the target platform:
/// - On Android: shows a Material dialog using [showDialog]
/// - On iOS: shows a Cupertino dialog using [showCupertinoDialog]
///
/// The dialog can be configured with platform-specific data through [materialDialogData]
/// and [cupertinoDialogData], or with common properties through [platformDialogData].
///
/// For Material dialogs, the builder is wrapped in a [Dialog] widget unless
/// `materialDialogData.fullscreenDialog` is true.
///
/// Example:
/// ```dart
/// showPlatformDialog(
///   context: context,
///   builder: (context) => PlatformAlertDialog(
///     title: Text('Confirm'),
///     content: Text('Are you sure?'),
///     actions: [
///       PlatformDialogAction(
///         child: Text('Cancel'),
///         onPressed: () => Navigator.pop(context),
///       ),
///       PlatformDialogAction(
///         child: Text('OK'),
///         onPressed: () => Navigator.pop(context),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// The following parameters only have an effect for Material dialogs when
/// `materialDialogData.fullscreenDialog` is false:
/// - [materialAlignment]: Alignment of the dialog
/// - [materialShape]: Shape of the dialog
/// - [materialClipBehavior]: Clip behavior of the dialog
/// - [materialConstraints]: Size constraints of the dialog
/// - [materialElevation]: Elevation of the dialog
/// - [materialInsetPadding]: Padding around the dialog
/// - [materialShadowColor]: Shadow color of the dialog
/// - [materialSurfaceTintColor]: Surface tint color of the dialog
Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
  PlatformDialogData? platformDialogData,
  MaterialDialogData? materialDialogData,
  PlatformDialogData? cupertinoDialogData,
  Key? materialKey,
  Color? materialBackgroundColor,
  Duration materialInsetAnimationDuration = _kMaterialInsetAnimationDuration,
  Curve materialInsetAnimationCurve = _kMaterialInsetAnimationCurve,
  SemanticsRole materialSemanticsRole = _kMaterialSemanticsRole,
  AlignmentGeometry? materialAlignment,
  ShapeBorder? materialShape,
  Clip? materialClipBehavior,
  BoxConstraints? materialConstraints,
  double? materialElevation,
  EdgeInsets? materialInsetPadding,
  Color? materialShadowColor,
  Color? materialSurfaceTintColor,
}) {
  assert(
    (builder == null) ^ (materialBuilder == null),
    'Either provide a builder or a materialBuilder.',
  );
  assert(
    (builder == null) ^ (cupertinoBuilder == null),
    'Either provide a builder or a cupertinoBuilder.',
  );

  return switch (defaultTargetPlatform) {
    .android => _runMaterialDialog<T>(
      context: context,
      materialBuilder: (context) =>
          (materialDialogData?.fullscreenDialog ?? MaterialDialogData.kDefaultFullscreenDialog)
          ? Dialog.fullscreen(
              key: materialKey,
              backgroundColor: materialBackgroundColor,
              insetAnimationDuration: materialInsetAnimationDuration,
              insetAnimationCurve: materialInsetAnimationCurve,
              semanticsRole: materialSemanticsRole,
              child: (materialBuilder ?? builder!)(context),
            )
          : Dialog(
              key: materialKey,
              backgroundColor: materialBackgroundColor,
              insetAnimationDuration: materialInsetAnimationDuration,
              insetAnimationCurve: materialInsetAnimationCurve,
              semanticsRole: materialSemanticsRole,
              alignment: materialAlignment,
              shape: materialShape,
              clipBehavior: materialClipBehavior,
              constraints: materialConstraints,
              elevation: materialElevation,
              insetPadding: materialInsetPadding,
              shadowColor: materialShadowColor,
              surfaceTintColor: materialSurfaceTintColor,
              child: (materialBuilder ?? builder!)(context),
            ),
      platformDialogData: platformDialogData,
      materialDialogData: materialDialogData,
    ),
    .iOS => _runCupertinoDialog<T>(
      context: context,
      cupertinoBuilder: cupertinoBuilder ?? builder!,
      platformDialogData: platformDialogData,
      cupertinoDialogData: cupertinoDialogData,
    ),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}

/// Material-only dispatch — extracted so the unused-platform branch is dead
/// code under AOT compilation when `defaultTargetPlatform` const-folds.
Future<T?> _runMaterialDialog<T>({
  required BuildContext context,
  required WidgetBuilder materialBuilder,
  PlatformDialogData? platformDialogData,
  MaterialDialogData? materialDialogData,
}) => showDialog<T>(
  context: context,
  builder: materialBuilder,
  anchorPoint: materialDialogData?.anchorPoint ?? platformDialogData?.anchorPoint,
  barrierColor: materialDialogData?.barrierColor ?? platformDialogData?.barrierColor,
  barrierDismissible:
      materialDialogData?.barrierDismissible ??
      platformDialogData?.barrierDismissible ??
      kCupertinoBarrierDismissible,
  barrierLabel: materialDialogData?.barrierLabel ?? platformDialogData?.barrierLabel,
  routeSettings: materialDialogData?.routeSettings ?? platformDialogData?.routeSettings,
  useRootNavigator:
      materialDialogData?.useRootNavigator ??
      platformDialogData?.useRootNavigator ??
      kDefaultUseRootNavigator,
  requestFocus: materialDialogData?.requestFocus ?? platformDialogData?.requestFocus,
  animationStyle: materialDialogData?.animationStyle,
  fullscreenDialog:
      materialDialogData?.fullscreenDialog ?? MaterialDialogData.kDefaultFullscreenDialog,
  traversalEdgeBehavior: materialDialogData?.traversalEdgeBehavior,
  useSafeArea: materialDialogData?.useSafeArea ?? MaterialDialogData.kDefaultUseSafeArea,
);

/// Cupertino-only dispatch — extracted so the unused-platform branch is dead
/// code under AOT compilation when `defaultTargetPlatform` const-folds.
Future<T?> _runCupertinoDialog<T>({
  required BuildContext context,
  required WidgetBuilder cupertinoBuilder,
  PlatformDialogData? platformDialogData,
  PlatformDialogData? cupertinoDialogData,
}) => showCupertinoDialog<T>(
  context: context,
  builder: cupertinoBuilder,
  anchorPoint: cupertinoDialogData?.anchorPoint ?? platformDialogData?.anchorPoint,
  barrierColor: cupertinoDialogData?.barrierColor ?? platformDialogData?.barrierColor,
  barrierDismissible:
      cupertinoDialogData?.barrierDismissible ??
      platformDialogData?.barrierDismissible ??
      kCupertinoBarrierDismissible,
  barrierLabel: cupertinoDialogData?.barrierLabel ?? platformDialogData?.barrierLabel,
  routeSettings: cupertinoDialogData?.routeSettings ?? platformDialogData?.routeSettings,
  useRootNavigator:
      cupertinoDialogData?.useRootNavigator ??
      platformDialogData?.useRootNavigator ??
      kDefaultUseRootNavigator,
  requestFocus: cupertinoDialogData?.requestFocus ?? platformDialogData?.requestFocus,
);

const _kMaterialInsetAnimationDuration = Duration(milliseconds: 100);
const _kMaterialInsetAnimationCurve = Curves.decelerate;
const _kMaterialSemanticsRole = SemanticsRole.dialog;

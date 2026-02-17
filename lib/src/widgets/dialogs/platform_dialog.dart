import 'dart:ui';

import 'package:flutter/cupertino.dart'
    show CupertinoAlertDialog, CupertinoDialogAction, showCupertinoDialog;
import 'package:flutter/material.dart'
    show AlertDialog, ButtonTheme, Colors, Dialog, TextButton, showDialog;
import 'package:flutter/widgets.dart';

import '/src/extensions/context_extensions.dart';
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
  final resolvedMaterialBuilder = materialBuilder ?? builder!;
  final resolvedCupertinoBuilder = cupertinoBuilder ?? builder!;

  return _showBasePlatformDialog<T>(
    context: context,
    materialBuilder: (context) =>
        (materialDialogData?.fullscreenDialog ?? MaterialDialogData.kDefaultFullscreenDialog)
        ? Dialog.fullscreen(
            key: materialKey,
            backgroundColor: materialBackgroundColor,
            insetAnimationDuration: materialInsetAnimationDuration,
            insetAnimationCurve: materialInsetAnimationCurve,
            semanticsRole: materialSemanticsRole,
            child: resolvedMaterialBuilder(context),
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
            child: resolvedMaterialBuilder(context),
          ),
    cupertinoBuilder: resolvedCupertinoBuilder,
    platformDialogData: platformDialogData,
    materialDialogData: materialDialogData,
    cupertinoDialogData: cupertinoDialogData,
  );
}

Future<T?> _showBasePlatformDialog<T>({
  required BuildContext context,
  required WidgetBuilder materialBuilder,
  required WidgetBuilder cupertinoBuilder,
  PlatformDialogData? platformDialogData,
  MaterialDialogData? materialDialogData,
  PlatformDialogData? cupertinoDialogData,
}) => context.platformLazyValue(
  material: () => showDialog<T>(
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
  ),
  cupertino: () => showCupertinoDialog<T>(
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
  ),
);

const _kMaterialInsetAnimationDuration = Duration(milliseconds: 100);
const _kMaterialInsetAnimationCurve = Curves.decelerate;
const _kMaterialSemanticsRole = SemanticsRole.dialog;

import 'dart:ui';

import 'package:flutter/cupertino.dart' show showCupertinoDialog;
import 'package:flutter/material.dart' show Dialog, showDialog;
import 'package:flutter/widgets.dart';

import '/extensions/context_extensions.dart';
import '/models/dialogs/const_values.dart';
import '/models/dialogs/platform_dialog_data.dart';

/// Conveniently wraps the `builder` in a [Dialog] for Material.
/// The following params only have an effect for `materialDialogData.fullscreenDialog == false`:
/// - [materialAlignment]
/// - [materialShape]
/// - [materialClipBehavior]
/// - [materialConstraints]
/// - [materialElevation]
/// - [materialInsetPadding]
/// - [materialShadowColor]
/// - [materialSurfaceTintColor]
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

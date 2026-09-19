import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoAlertDialog, CupertinoDialogAction, CupertinoPopupSurface, showCupertinoDialog;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show AlertDialog, ButtonTheme, Colors, Dialog, TextButton, showDialog;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import '/src/models/dialogs/platform_dialog_data.dart';
import '/src/models/platform_widget_base.dart';

part 'platform_alert_dialog.dart';

/// Shows a centred modal dialog, wrapping your content in a [Dialog] on Android and a [CupertinoPopupSurface]
/// on iOS. Want to bring your own surface, or none at all? That's [showPlatformRawDialog].
///
/// Give it content that sizes itself, a [Column] with `mainAxisSize: .min` say. The Cupertino route
/// hands the builder the whole screen, so anything unbounded stretches the card to fill it.
///
/// **On iOS, tapping the barrier does nothing by default.** That matches the HIG, where an alert is
/// dismissed by a button rather than by tapping away, and there's no system back button to fall back
/// on. So your content needs its own way out or the dialog is a dead end. `barrierDismissible: true`
/// opts into the non-standard behaviour.
///
/// Fullscreen is [showPlatformFullscreenDialog]. iOS has no such thing and shows the same centred dialog
/// either way. For a genuinely fullscreen iOS presentation, push a `CupertinoPageRoute` with `fullscreenDialog: true`
/// yourself.
///
/// Either pass [builder] for content shared across both, or pass [materialBuilder] and [cupertinoBuilder]
/// together. Mixing the 2 trips an assert.
///
/// [materialDialogData] tunes the Android side. There's no Cupertino equivalent, since [showCupertinoDialog]
/// takes nothing beyond the flat args already here.
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_dialog.dart#platform_dialog}
Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  String? barrierLabel,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialDialogData? materialDialogData,
}) {
  _assertBuilderInvariant(
    hasBuilder: builder != null,
    hasMaterialBuilder: materialBuilder != null,
    hasCupertinoBuilder: cupertinoBuilder != null,
  );

  return switch (defaultTargetPlatform) {
    .android => _showMaterialDialog(
      context: context,
      // Wrap the user's content in a Dialog, the package's centered
      // convenience over upstream's raw `showDialog(builder: …)`.
      builder: (context) => Dialog(
        backgroundColor: materialDialogData?.backgroundColor,
        insetAnimationDuration:
            materialDialogData?.insetAnimationDuration ??
            kDefaultMaterialDialogInsetAnimationDuration,
        insetAnimationCurve:
            materialDialogData?.insetAnimationCurve ?? kDefaultMaterialDialogInsetAnimationCurve,
        semanticsRole: materialDialogData?.semanticsRole ?? kDefaultMaterialDialogSemanticsRole,
        alignment: materialDialogData?.alignment,
        shape: materialDialogData?.shape,
        clipBehavior: materialDialogData?.clipBehavior,
        constraints: materialDialogData?.constraints,
        elevation: materialDialogData?.elevation,
        insetPadding: materialDialogData?.insetPadding,
        shadowColor: materialDialogData?.shadowColor,
        surfaceTintColor: materialDialogData?.surfaceTintColor,
        child: (materialBuilder ?? builder!)(context),
      ),
      isFullscreenRoute: false,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
      animationStyle: materialDialogData?.animationStyle,
      traversalEdgeBehavior: materialDialogData?.traversalEdgeBehavior,
      useSafeArea: materialDialogData?.useSafeArea ?? kDefaultMaterialDialogUseSafeArea,
    ),
    .iOS => _showCupertinoDialog(
      context: context,
      // iOS counterpart to the Android Dialog wrap. See _cupertinoDialogSurface.
      builder: _cupertinoDialogSurface(cupertinoBuilder ?? builder!),
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
    ),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}

/// Shows a fullscreen modal dialog on Android, via [Dialog.fullscreen]. iOS has no such concept and
/// gets the same centred dialog [showPlatformDialog] would give it.
///
/// [MaterialFullscreenDialogData] deliberately carries fewer fields than [MaterialDialogData], only
/// the ones [Dialog.fullscreen] actually honours. The centred-only knobs stay over there, which is how
/// the old design used to lose them without saying anything.
///
/// Builder selection and the iOS dismissal caveat work exactly as in [showPlatformDialog].
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_dialog.dart#fullscreen_dialog}
Future<T?> showPlatformFullscreenDialog<T>({
  required BuildContext context,
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  String? barrierLabel,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialFullscreenDialogData? materialDialogData,
}) {
  _assertBuilderInvariant(
    hasBuilder: builder != null,
    hasMaterialBuilder: materialBuilder != null,
    hasCupertinoBuilder: cupertinoBuilder != null,
  );

  return switch (defaultTargetPlatform) {
    .android => _showMaterialDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: materialDialogData?.backgroundColor,
        insetAnimationDuration:
            materialDialogData?.insetAnimationDuration ??
            kDefaultMaterialDialogInsetAnimationDuration,
        insetAnimationCurve:
            materialDialogData?.insetAnimationCurve ?? kDefaultMaterialDialogInsetAnimationCurve,
        semanticsRole: materialDialogData?.semanticsRole ?? kDefaultMaterialDialogSemanticsRole,
        child: (materialBuilder ?? builder!)(context),
      ),
      isFullscreenRoute: true,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
      animationStyle: materialDialogData?.animationStyle,
      traversalEdgeBehavior: materialDialogData?.traversalEdgeBehavior,
      useSafeArea: materialDialogData?.useSafeArea ?? kDefaultMaterialDialogUseSafeArea,
    ),
    .iOS => _showCupertinoDialog(
      context: context,
      // iOS counterpart to the Android Dialog wrap. See _cupertinoDialogSurface.
      builder: _cupertinoDialogSurface(cupertinoBuilder ?? builder!),
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
    ),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}

/// Shows a modal dialog with no surface wrapped around your content at all. You get the platform's barrier
/// and transition, and everything inside is yours: a floating image, a hand-painted card, an onboarding
/// coachmark.
///
/// Worth reaching for when [showPlatformDialog]'s card is in the way, say when you're dropping in your
/// own [CupertinoAlertDialog] and don't want it double-wrapped, or going full-bleed.
///
/// Builder selection and the iOS dismissal caveat work exactly as in [showPlatformDialog]. No `materialDialogData`
/// here, since there's no [Dialog] left to configure.
Future<T?> showPlatformRawDialog<T>({
  required BuildContext context,
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  String? barrierLabel,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
}) {
  _assertBuilderInvariant(
    hasBuilder: builder != null,
    hasMaterialBuilder: materialBuilder != null,
    hasCupertinoBuilder: cupertinoBuilder != null,
  );

  return switch (defaultTargetPlatform) {
    .android => _showMaterialDialog(
      context: context,
      // No Dialog wrap, the caller owns the surface.
      builder: materialBuilder ?? builder!,
      isFullscreenRoute: false,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
      animationStyle: null,
      traversalEdgeBehavior: null,
      useSafeArea: kDefaultMaterialDialogUseSafeArea,
    ),
    .iOS => _showCupertinoDialog(
      context: context,
      // No CupertinoPopupSurface wrap, the caller owns the surface.
      builder: cupertinoBuilder ?? builder!,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
    ),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}

/// Takes booleans rather than the builders themselves. 2 function-typed `material*`/`cupertino*` params
/// would trip the AOT-pruning guard in `test/aot_pruning_regression_test.dart`, even though a null check
/// alone can't keep either branch reachable.
void _assertBuilderInvariant({
  required bool hasBuilder,
  required bool hasMaterialBuilder,
  required bool hasCupertinoBuilder,
}) {
  assert(
    hasBuilder || (hasMaterialBuilder && hasCupertinoBuilder),
    'Provide either `builder` (for both platforms) or both `materialBuilder` '
    'and `cupertinoBuilder`.',
  );
  assert(
    !hasBuilder || (!hasMaterialBuilder && !hasCupertinoBuilder),
    'If `builder` is provided, do not also provide `materialBuilder` or '
    '`cupertinoBuilder`.',
  );
}

/// Takes an already-wrapped [builder] and just marshals arguments. Top-level rather than inline so the
/// unused platform's branch const-folds away under AOT.
Future<T?> _showMaterialDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required bool isFullscreenRoute,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required bool? barrierDismissible,
  required String? barrierLabel,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
  required AnimationStyle? animationStyle,
  required TraversalEdgeBehavior? traversalEdgeBehavior,
  required bool useSafeArea,
}) => showDialog(
  context: context,
  builder: builder,
  anchorPoint: anchorPoint,
  barrierColor: barrierColor,
  barrierDismissible: barrierDismissible ?? kMaterialBarrierDismissible,
  barrierLabel: barrierLabel,
  routeSettings: routeSettings,
  useRootNavigator: useRootNavigator,
  requestFocus: requestFocus,
  animationStyle: animationStyle,
  fullscreenDialog: isFullscreenRoute,
  traversalEdgeBehavior: traversalEdgeBehavior,
  useSafeArea: useSafeArea,
);

/// Shared Cupertino-side route-show plumbing. See [_showMaterialDialog].
Future<T?> _showCupertinoDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required bool? barrierDismissible,
  required String? barrierLabel,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
}) => showCupertinoDialog(
  context: context,
  builder: builder,
  anchorPoint: anchorPoint,
  barrierColor: barrierColor,
  barrierDismissible: barrierDismissible ?? kCupertinoBarrierDismissible,
  barrierLabel: barrierLabel,
  routeSettings: routeSettings,
  useRootNavigator: useRootNavigator,
  requestFocus: requestFocus,
);

/// iOS's answer to the [Dialog] the Android branch wraps on. [showCupertinoDialog]'s route only paints
/// the barrier and runs the transition, so without this the content floats on the dim with no card.
///
/// Kept out of [_showCupertinoDialog] because [showPlatformAlertDialog] brings its own surface and would
/// end up double-wrapped.
WidgetBuilder _cupertinoDialogSurface(WidgetBuilder content) =>
    (context) => Center(child: CupertinoPopupSurface(child: content(context)));

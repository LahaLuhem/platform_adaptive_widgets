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

/// Shows a centered modal dialog. The [builder]'s widget is wrapped in a
/// platform dialog surface: Material [Dialog] on Android (via [showDialog]),
/// and a screen-centered [CupertinoPopupSurface] on iOS (via
/// [showCupertinoDialog], whose route paints only the barrier, not a surface).
///
/// Pass intrinsically-sized content (e.g. a [Column] with
/// `mainAxisSize: MainAxisSize.min`). The Cupertino route hands the builder the
/// full screen, so an unbounded child — a [Center], or a default-`max` [Column]
/// — stretches the surface to fill it.
///
/// **Dismissal on iOS:** the barrier is not tap-to-dismiss by default
/// (`barrierDismissible` is `false` — matching the iOS HIG, where alerts are
/// dismissed by a button, not by tapping outside). Give the content its own
/// dismiss / confirm affordance (e.g. a button that pops the route), or the
/// dialog is a dead-end on iOS — there is no system back button. Pass
/// `barrierDismissible: true` only to opt into the non-standard tap-outside
/// behaviour.
///
/// For fullscreen modals, use [showPlatformFullscreenDialog] — that variant
/// uses [Dialog.fullscreen] on Material and exposes only the fullscreen-valid
/// params via [MaterialFullscreenDialogData]. iOS has no native fullscreen
/// dialog; both functions present the same centered Cupertino dialog on iOS.
/// For iOS-style fullscreen route presentation, push a `CupertinoPageRoute`
/// with `fullscreenDialog: true` directly.
///
/// Content selection:
/// - Pass [builder] for shared content on both platforms.
/// - Or pass both [materialBuilder] and [cupertinoBuilder] for per-platform
///   content.
/// - Combining `builder` with a platform-specific builder fires an assert.
///
/// Per-platform Material tuning is opt-in via [materialDialogData] — fields
/// for the centered [Dialog] (`alignment`, `shape`, `clipBehavior`, …) plus
/// the [showDialog] knobs (`animationStyle`, `traversalEdgeBehavior`,
/// `useSafeArea`). [showCupertinoDialog] has no params beyond the shared
/// show-function flat args — no Cupertino data record exists.
///
/// Example:
/// ```dart
/// final result = await showPlatformDialog<String>(
///   context: context,
///   builder: (context) => Padding(
///     padding: const EdgeInsets.all(16),
///     child: Column(mainAxisSize: MainAxisSize.min, children: [
///       ...,
///       TextButton(
///         onPressed: () => Navigator.maybeOf(context)?.pop('chosen'),
///         child: const Text('Confirm'),
///       ),
///     ]),
///   ),
/// );
/// ```
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
      // Wrap the user's content in a Dialog — the package's centered
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
      // iOS counterpart to the Android Dialog wrap — see _cupertinoDialogSurface.
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

/// Shows a fullscreen modal dialog. The [builder]'s widget is wrapped in
/// Material [Dialog.fullscreen] on Android (and shown via [showDialog] with
/// `fullscreenDialog: true` to also flip the route presentation); on iOS the
/// widget is wrapped in a screen-centered [CupertinoPopupSurface] and shown via
/// [showCupertinoDialog] — Cupertino has no native fullscreen-dialog concept,
/// so the iOS branch presents the same centered dialog as [showPlatformDialog].
///
/// Material's surface is split: [MaterialFullscreenDialogData] exposes only
/// the [Dialog.fullscreen]-valid params (background, animation, semantics,
/// safe-area, traversal). The centered-only knobs (`alignment`, `shape`,
/// `clipBehavior`, `constraints`, `elevation`, `insetPadding`, `shadowColor`,
/// `surfaceTintColor`) live on [MaterialDialogData] under [showPlatformDialog]
/// — this kills the v1 footgun where they were silently dropped when
/// `fullscreenDialog: true` was set.
///
/// Content-builder selection — and the iOS dismissal caveat (the barrier isn't
/// tap-to-dismiss by default, so content needs its own dismiss affordance) —
/// follows the same rules as [showPlatformDialog].
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
      // iOS counterpart to the Android Dialog wrap — see _cupertinoDialogSurface.
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

/// Asserts exactly one of the two valid builder-input shapes was used:
/// `builder` alone, or both `materialBuilder` and `cupertinoBuilder` together.
///
/// Takes the args' *nullness* rather than the builders themselves: passing the
/// `WidgetBuilder`s in would name two function-typed `material*`/`cupertino*`
/// params and trip the AOT-pruning guard
/// (`test/aot_pruning_regression_test.dart`), even though a null-only check
/// can't keep either platform's code reachable. Booleans satisfy the contract
/// and the guard both. Used by [showPlatformDialog] and
/// [showPlatformFullscreenDialog].
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

/// Shared Material-side route-show plumbing — marshals the [showDialog]
/// arguments without imposing any content wrapping. Callers pass an
/// already-shaped [builder] (the user's widget pre-wrapped in [Dialog] /
/// [Dialog.fullscreen] / [AlertDialog] as appropriate).
///
/// Extracted to a top-level function so the unused-platform branch of
/// `switch (defaultTargetPlatform)` is dead code under AOT compilation when
/// the platform const-folds.
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

/// Shared Cupertino-side route-show plumbing — see [_showMaterialDialog].
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

/// Wraps [content] in a screen-centered [CupertinoPopupSurface] — the iOS
/// counterpart to the Material [Dialog] the Android branch applies in
/// [showPlatformDialog] / [showPlatformFullscreenDialog]. Needed because
/// [showCupertinoDialog]'s route paints only the barrier and runs the transition
/// (its transition builder returns the child unchanged); the route is *not* a
/// visual shell, so unwrapped content would float on the dim with no card.
///
/// Deliberately not folded into [_showCupertinoDialog]: [showPlatformAlertDialog]
/// builds its own [CupertinoAlertDialog] (which already carries a surface), so it
/// must skip this to avoid double-wrapping.
WidgetBuilder _cupertinoDialogSurface(WidgetBuilder content) =>
    (context) => Center(child: CupertinoPopupSurface(child: content(context)));

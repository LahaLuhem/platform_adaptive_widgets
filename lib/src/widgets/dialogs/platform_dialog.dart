import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoAlertDialog,
        CupertinoDialogAction,
        CupertinoPageRoute,
        CupertinoPopupSurface,
        showCupertinoDialog;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show AlertDialog, ButtonTheme, Colors, Dialog, TextButton, showDialog;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import '/src/models/dialogs/platform_dialog_data.dart';
import '/src/models/layout/platform_app_bar_data.dart';
import '/src/models/platform_widget_base.dart';
import '/src/widgets/layout/platform_scaffold.dart';

part 'platform_alert_dialog.dart';

/// Shows a centred modal dialog, wrapping your content in a [Dialog] on Android and a [CupertinoPopupSurface]
/// on iOS. Want to bring your own surface, or none at all? That's [showPlatformRawDialog].
///
/// Give it content that sizes itself, a [Column] with `mainAxisSize: .min` say. The Cupertino route
/// hands the builder the whole screen, so anything unbounded stretches the card to fill it.
///
/// **On iOS, tapping outside does nothing by default.** That matches the HIG, where an alert closes from
/// a button rather than a tap outside, and there's no system back button to fall back on. So your
/// content needs its own way out, or the dialog is a dead end. `barrierDismissible: true` opts out.
///
/// Full-screen is [showPlatformFullscreenDialog].
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

/// Shows a full-screen modal dialog: [Dialog.fullscreen] on Android, a full-screen [CupertinoPageRoute]
/// on iOS.
///
/// You hand over the page's parts, the bar and the body, and the package builds a [PlatformScaffold]
/// from them. That way the bar gets each platform's close button (M3's X, iOS's Cancel) and the body
/// sits on a page background. On iOS the bar is the only way out, since a full-screen page can't be
/// swiped back.
///
/// [MaterialFullscreenDialogData] only carries the fields [Dialog.fullscreen] honours, so a centred
/// dialog's knobs can't be passed here and quietly do nothing.
///
/// Guidelines: [M3 full-screen dialogs](https://m3.material.io/components/dialogs/guidelines),
/// [HIG full-screen modals](https://developer.apple.com/design/human-interface-guidelines/modality#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_dialog.dart#fullscreen_dialog}
Future<T?> showPlatformFullscreenDialog<T>({
  required BuildContext context,
  required PlatformAppBarData appBarData,
  required WidgetBuilder builder,
  Color? backgroundColor,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialFullscreenDialogData? materialDialogData,
}) {
  final page = _fullscreenPage(
    appBarData: appBarData,
    backgroundColor: backgroundColor,
    body: builder,
  );

  return switch (defaultTargetPlatform) {
    .android => _showMaterialDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        insetAnimationDuration:
            materialDialogData?.insetAnimationDuration ??
            kDefaultMaterialDialogInsetAnimationDuration,
        insetAnimationCurve:
            materialDialogData?.insetAnimationCurve ?? kDefaultMaterialDialogInsetAnimationCurve,
        semanticsRole: materialDialogData?.semanticsRole ?? kDefaultMaterialDialogSemanticsRole,
        child: page(context),
      ),
      isFullscreenRoute: true,
      // A full-screen dialog has no outside, so the barrier settings don't apply and it covers the status bar.
      barrierDismissible: false,
      barrierColor: null,
      barrierLabel: null,
      useSafeArea: false,
      anchorPoint: materialDialogData?.anchorPoint,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
      animationStyle: materialDialogData?.animationStyle,
      traversalEdgeBehavior: materialDialogData?.traversalEdgeBehavior,
    ),
    .iOS => _showCupertinoFullscreenDialog(
      context: context,
      builder: page,
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
/// own [CupertinoAlertDialog] and don't want it double-wrapped, or going edge to edge.
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

/// Takes an already-wrapped [builder] and only passes arguments along. Top-level rather than inline, so
/// release builds can drop the other platform's branch.
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

/// A page route rather than a dialog one, since that's what iOS's full-screen modal is. See [_showMaterialDialog].
Future<T?> _showCupertinoFullscreenDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
}) => Navigator.of(context, rootNavigator: useRootNavigator).push(
  CupertinoPageRoute<T>(
    builder: builder,
    settings: routeSettings,
    requestFocus: requestFocus,
    fullscreenDialog: true,
  ),
);

/// iOS's answer to the [Dialog] the Android branch wraps on. [showCupertinoDialog]'s route only paints
/// the barrier and runs the transition, so without this the content floats on the dim with no card.
///
/// Kept out of [_showCupertinoDialog] because [showPlatformAlertDialog] brings its own surface and would
/// end up double-wrapped.
WidgetBuilder _cupertinoDialogSurface(WidgetBuilder content) =>
    (context) => Center(child: CupertinoPopupSurface(child: content(context)));

/// Built by the package rather than the caller, so the close button and page background can't be
/// forgotten.
WidgetBuilder _fullscreenPage({
  required PlatformAppBarData appBarData,
  required Color? backgroundColor,
  required WidgetBuilder body,
}) =>
    (context) => PlatformScaffold(
      appBarData: appBarData,
      backgroundColor: backgroundColor,
      body: body(context),
    );

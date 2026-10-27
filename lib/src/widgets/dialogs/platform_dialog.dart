/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_alert_dialog.dart';
/// @docImport '/src/widgets/dialogs/platform_sheet.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPageRoute, CupertinoPopupSurface;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Dialog;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_dialog_data.dart';
import '/src/models/layout/platform_app_bar_data.dart';
import '/src/utils/design_language.dart';
import '/src/widgets/layout/platform_scaffold.dart';
import 'dialog_routes.dart';

/// Shows a centred modal dialog, wrapping your content in a [Dialog] on Material and a [CupertinoPopupSurface]
/// on Cupertino. Want to bring your own surface, or none at all? That's [showPlatformRawDialog].
///
/// Give it content that sizes itself, a [Column] with `mainAxisSize: .min` say. The Cupertino route
/// hands the builder the whole screen, so anything unbounded stretches the card to fill it.
///
/// **On Cupertino, tapping outside does nothing by default.** That matches the HIG, where an alert closes
/// from a button rather than a tap outside, and there's no system back button to fall back on. So your
/// content needs its own way out, or the dialog is a dead end. `barrierDismissible: true` opts out.
///
/// Full-screen is [showPlatformFullscreenDialog].
///
/// Either pass [builder] for content shared across both, or pass [materialBuilder] and [cupertinoBuilder]
/// together. Mixing the 2 trips an assert.
///
/// [materialDialogData] tunes the Material side. There's no Cupertino equivalent, since [showCupertinoDialog]
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

  return switch (designLanguage) {
    .material => showMaterialDialogRoute(
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
    .cupertino => showCupertinoDialogRoute(
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
  };
}

/// Shows a full-screen modal dialog: [Dialog.fullscreen] on Material, a full-screen [CupertinoPageRoute]
/// on Cupertino. It's for long or multistep tasks. Extra content or a short task fits [showPlatformSheet].
///
/// You hand over the page's parts, the bar and the body, and the package builds a [PlatformScaffold]
/// from them. That way the bar gets each platform's close button (M3's X, Cupertino's Cancel) and the
/// body sits on a page background. On Cupertino the bar is the only way out, since a full-screen page
/// can't be swiped back.
///
/// Both builders get the dialog's own context, so an action in the bar, like a Save, closes this dialog
/// through it, whichever navigator opened it.
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
  required PlatformAppBarData Function(BuildContext context) appBarBuilder,
  required WidgetBuilder builder,
  Color? backgroundColor,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialFullscreenDialogData? materialDialogData,
}) {
  // Built by the package rather than the caller, so the close button and page background can't be
  // forgotten.
  Widget page(BuildContext context) => PlatformScaffold(
    appBarData: appBarBuilder(context),
    backgroundColor: backgroundColor,
    body: builder(context),
  );

  return switch (designLanguage) {
    .material => showMaterialDialogRoute(
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
    .cupertino => _showCupertinoFullscreenDialog(
      context: context,
      builder: page,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
    ),
  };
}

/// Shows a modal dialog with no surface wrapped around your content at all. You get the platform's barrier
/// and transition, and everything inside is yours: a floating image, a hand-painted card, an onboarding
/// coachmark.
///
/// Worth reaching for when [showPlatformDialog]'s card is in the way, say when you're dropping in your
/// own [CupertinoAlertDialog] and don't want it double-wrapped, or going edge to edge.
///
/// Builder selection and the Cupertino dismissal caveat work exactly as in [showPlatformDialog]. No
/// `materialDialogData` here, since there's no [Dialog] left to configure.
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

  return switch (designLanguage) {
    .material => showMaterialDialogRoute(
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
    .cupertino => showCupertinoDialogRoute(
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

/// A page route rather than a dialog one, since that's what a Cupertino full-screen modal is. See [showMaterialDialogRoute].
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

/// Cupertino's answer to the [Dialog] the Material branch wraps on. [showCupertinoDialog]'s route only
/// paints the barrier and runs the transition, so without this the content floats on the dim with no
/// card.
///
/// Kept out of [showCupertinoDialogRoute] because [showPlatformAlertDialog] brings its own surface and would
/// end up double-wrapped.
WidgetBuilder _cupertinoDialogSurface(WidgetBuilder content) =>
    (context) => Center(child: CupertinoPopupSurface(child: content(context)));

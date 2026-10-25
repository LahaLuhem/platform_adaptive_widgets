// The alert's own action button lives with the alert.
// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoAlertDialog, CupertinoDialogAction;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show AlertDialog, TextButton;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import '/src/models/dialogs/platform_dialog_data.dart';
import '/src/models/platform_widget_base.dart';
import '/src/utils/design_language.dart';
import 'dialog_routes.dart';

/// M3 pads a dialog 24 on every side, where Flutter leaves only its under-title gap of 16 above an
/// untitled message ([flutter/flutter#195096](https://github.com/flutter/flutter/issues/195096)).
const _kMaterialUntitledContentPadding = EdgeInsets.all(24);

/// The alert under `showPlatformAcknowledge` and `showPlatformConfirm`, [AlertDialog] on Material and
/// [CupertinoAlertDialog] on Cupertino. Not exported, so only those jobs pick its actions.
Future<T?> showPlatformAlertDialog<T>({
  required BuildContext context,
  // The HIG gives every alert one.
  required Widget title,
  Widget? content,
  List<Widget> actions = const <Widget>[],
  Key? widgetKey,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  String? barrierLabel,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialAlertDialogData? materialAlertDialogData,
  CupertinoAlertDialogData? cupertinoAlertDialogData,
}) => switch (designLanguage) {
  .material => showMaterialDialogRoute(
    context: context,
    // AlertDialog is itself a Dialog under the hood, no wrapping needed.
    builder: (_) => AlertDialog(
      key: widgetKey,
      // M3 needs text but not a headline, so a lone title becomes the text.
      title: content == null ? null : title,
      content: content ?? title,
      actions: actions,
      icon: materialAlertDialogData?.icon,
      iconPadding: materialAlertDialogData?.iconPadding,
      iconColor: materialAlertDialogData?.iconColor,
      titlePadding: materialAlertDialogData?.titlePadding,
      titleTextStyle: materialAlertDialogData?.titleTextStyle,
      contentPadding:
          materialAlertDialogData?.contentPadding ??
          // An icon keeps M3's gap of 16 under it, which Flutter already gets right.
          (content == null && materialAlertDialogData?.icon == null
              ? _kMaterialUntitledContentPadding
              : null),
      contentTextStyle: materialAlertDialogData?.contentTextStyle,
      actionsPadding: materialAlertDialogData?.actionsPadding,
      actionsAlignment: materialAlertDialogData?.actionsAlignment,
      actionsOverflowAlignment: materialAlertDialogData?.actionsOverflowAlignment,
      actionsOverflowDirection:
          materialAlertDialogData?.actionsOverflowDirection ??
          kDefaultMaterialAlertDialogActionsOverflowDirection,
      actionsOverflowButtonSpacing: materialAlertDialogData?.actionsOverflowButtonSpacing,
      buttonPadding: materialAlertDialogData?.buttonPadding,
      backgroundColor: materialAlertDialogData?.backgroundColor,
      elevation: materialAlertDialogData?.elevation,
      shadowColor: materialAlertDialogData?.shadowColor,
      surfaceTintColor: materialAlertDialogData?.surfaceTintColor,
      semanticLabel: materialAlertDialogData?.semanticLabel,
      insetPadding: materialAlertDialogData?.insetPadding,
      clipBehavior: materialAlertDialogData?.clipBehavior,
      shape: materialAlertDialogData?.shape,
      alignment: materialAlertDialogData?.alignment,
      constraints: materialAlertDialogData?.constraints,
      scrollable: materialAlertDialogData?.scrollable ?? kDefaultMaterialAlertDialogScrollable,
    ),
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
    builder: (_) => CupertinoAlertDialog(
      key: widgetKey,
      title: title,
      content: content,
      actions: actions,
      scrollController: cupertinoAlertDialogData?.scrollController,
      actionScrollController: cupertinoAlertDialogData?.actionScrollController,
      insetAnimationDuration:
          cupertinoAlertDialogData?.insetAnimationDuration ??
          kDefaultCupertinoAlertDialogInsetAnimationDuration,
      insetAnimationCurve:
          cupertinoAlertDialogData?.insetAnimationCurve ??
          kDefaultCupertinoAlertDialogInsetAnimationCurve,
    ),
    anchorPoint: anchorPoint,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
    requestFocus: requestFocus,
  ),
};

/// A button for [showPlatformAlertDialog]'s `actions` list. [TextButton] on Material, [CupertinoDialogAction]
/// on Cupertino.
class const PlatformDialogAction({
  required super.child,

  /// Gets the *dialog's* context, not the screen's, so `Navigator.maybeOf(context)?.pop(value)` inside
  /// it dismisses the dialog and hands back a result.
  final ValueChanged<BuildContext>? onPressed,

  /// Turns the label red on Cupertino. Material has no destructive style.
  final bool isDestructiveAction = false,

  /// Bolds the label on Cupertino. Material has no notion of a default action, so nothing happens there.
  final bool isDefaultAction = false,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBuilderBase {
  /// Creates a platform-adaptive dialog action.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) =>
      TextButton(onPressed: onPressed == null ? null : () => onPressed!(context), child: child);

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) => CupertinoDialogAction(
    onPressed: onPressed == null ? null : () => onPressed!(context),
    isDestructiveAction: isDestructiveAction,
    isDefaultAction: isDefaultAction,
    child: child,
  );
}

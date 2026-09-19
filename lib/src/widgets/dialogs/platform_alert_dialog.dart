// ignore_for_file: prefer-match-file-name

part of 'platform_dialog.dart';

/// Shows an alert dialog, Material [AlertDialog] on Android and [CupertinoAlertDialog] on iOS: an optional
/// [title] over an optional [content], with [actions] underneath, usually [PlatformDialogAction]s.
///
/// The content slots are flat here and used on both platforms. Styling goes in [materialAlertDialogData]
/// / [cupertinoAlertDialogData].
///
/// No `materialDialogData` knob, because [AlertDialog] already is a [Dialog] and nothing wraps it.
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_alert_dialog.dart#platform_alert_dialog}
Future<T?> showPlatformAlertDialog<T>({
  required BuildContext context,
  Widget? title,
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
}) => switch (defaultTargetPlatform) {
  .android => _showMaterialDialog(
    context: context,
    // AlertDialog is itself a Dialog under the hood, no wrapping needed.
    builder: (_) => AlertDialog(
      key: widgetKey,
      title: title,
      content: content,
      actions: actions,
      icon: materialAlertDialogData?.icon,
      iconPadding: materialAlertDialogData?.iconPadding,
      iconColor: materialAlertDialogData?.iconColor,
      titlePadding: materialAlertDialogData?.titlePadding,
      titleTextStyle: materialAlertDialogData?.titleTextStyle,
      contentPadding: materialAlertDialogData?.contentPadding,
      contentTextStyle: materialAlertDialogData?.contentTextStyle,
      actionsPadding: materialAlertDialogData?.actionsPadding,
      actionsAlignment: materialAlertDialogData?.actionsAlignment,
      actionsOverflowAlignment: materialAlertDialogData?.actionsOverflowAlignment,
      actionsOverflowDirection: materialAlertDialogData?.actionsOverflowDirection,
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
  .iOS => _showCupertinoDialog(
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
  _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
};

/// A button for [showPlatformAlertDialog]'s `actions` list. [TextButton] on Android, [CupertinoDialogAction]
/// on iOS.
class const PlatformDialogAction({
  required super.child,

  /// Gets the *dialog's* context, not the screen's, so `Navigator.maybeOf(context)?.pop(value)` inside
  /// it dismisses the dialog and hands back a result.
  final ValueChanged<BuildContext>? onPressed,

  /// Turns the label red on both platforms, via [ButtonTheme]'s `colorScheme.error` on Material.
  final bool isDestructiveAction = false,

  /// Bolds the label on iOS. Material has no notion of a default action, so nothing happens there.
  final bool isDefaultAction = false,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBuilderBase {
  /// Creates a platform-adaptive dialog action.
  this;

  @override
  Widget buildMaterial(BuildContext context) => TextButton(
    onPressed: onPressed == null ? null : () => onPressed!(context),
    style: !isDestructiveAction
        ? null
        : TextButton.styleFrom(
            foregroundColor: ButtonTheme.of(context).colorScheme?.error ?? Colors.red,
          ),
    child: child,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoDialogAction(
    onPressed: onPressed == null ? null : () => onPressed!(context),
    isDestructiveAction: isDestructiveAction,
    isDefaultAction: isDefaultAction,
    child: child,
  );
}

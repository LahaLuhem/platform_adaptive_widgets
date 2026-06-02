// ignore_for_file: prefer-match-file-name

part of 'platform_dialog.dart';

/// Shows a centered alert dialog — Material [AlertDialog] on Android,
/// [CupertinoAlertDialog] on iOS. The standard structure: optional [title]
/// over optional [content], with a row of [actions] underneath (typically
/// [PlatformDialogAction] instances).
///
/// Content slots ([title], [content], [actions], [widgetKey]) are flat on the
/// show function — set them once and they're used on both platforms. Material-
/// or Cupertino-specific styling lives on [materialAlertDialogData] /
/// [cupertinoAlertDialogData].
///
/// Uses the same shared show-function flat args as [showPlatformDialog]
/// (`anchorPoint`, `barrierColor`, `barrierDismissible`, `barrierLabel`,
/// `routeSettings`, `useRootNavigator`, `requestFocus`). The Material-side
/// `Dialog`-wrapping params (alignment / shape / clipBehavior / etc.) don't
/// apply — [AlertDialog] is its own [Dialog] under the hood, so no
/// [MaterialDialogData] knob is needed.
///
/// Example:
/// ```dart
/// final confirmed = await showPlatformAlertDialog<bool>(
///   context: context,
///   title: const Text('Delete?'),
///   content: const Text('This cannot be undone.'),
///   actions: [
///     PlatformDialogAction(
///       onPressed: (context) => Navigator.maybeOf(context)?.pop(false),
///       child: const Text('Cancel'),
///     ),
///     PlatformDialogAction(
///       isDestructiveAction: true,
///       onPressed: (context) => Navigator.maybeOf(context)?.pop(true),
///       child: const Text('Delete'),
///     ),
///   ],
/// );
/// ```
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
    // AlertDialog is itself a Dialog under the hood — no wrapping needed.
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

/// A platform-adaptive action button for use inside [showPlatformAlertDialog]'s
/// `actions` list. Renders [TextButton] on Android, [CupertinoDialogAction] on
/// iOS.
///
/// **Styling.** [isDestructiveAction] renders the button in red text on
/// Cupertino and with red foreground on Material (overrides via
/// [ButtonTheme]'s `colorScheme.error`). [isDefaultAction] renders bold text
/// on Cupertino; Material doesn't have a "default action" concept upstream,
/// so the flag is Cupertino-only at render time.
///
/// **Callback signature.** [onPressed] receives the *dialog's* [BuildContext]
/// (not the surrounding screen's) — call `Navigator.maybeOf(context)?.pop(value)`
/// from inside the callback to dismiss the dialog with a return value.
///
/// Renamed from `PlatformAlertDialogActionButton` in v2 — shorter, mirrors
/// iOS's `CupertinoDialogAction` naming.
class PlatformDialogAction extends PlatformWidgetKeyedBuilderBase {
  /// Callback fired when the action is pressed. Receives the dialog's context.
  final ValueChanged<BuildContext>? onPressed;

  /// Whether this action represents a destructive operation (delete, etc.).
  /// Renders in red text on Cupertino, red foreground on Material.
  final bool isDestructiveAction;

  /// Whether this is the dialog's default action. Renders bold on Cupertino;
  /// Material doesn't surface a "default action" concept upstream.
  final bool isDefaultAction;

  /// Creates a platform-adaptive dialog action.
  const PlatformDialogAction({
    required super.child,
    this.onPressed,
    this.isDestructiveAction = false,
    this.isDefaultAction = false,
    super.widgetKey,
    super.key,
  });

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

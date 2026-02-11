// ignore_for_file: prefer-match-file-name

part of 'platform_dialog.dart';

/// Shows a platform-adaptive alert dialog that renders Material AlertDialog on Android
/// and CupertinoAlertDialog on iOS.
///
/// This function automatically selects the appropriate alert dialog implementation based on the target platform:
/// - On Android: shows a Material Design AlertDialog
/// - On iOS: shows a CupertinoAlertDialog
///
/// The alert dialog can be configured with platform-specific data through [materialAlertDialogData]
/// and [cupertinoAlertDialogData], or with common properties.
///
/// Example:
/// ```dart
/// showPlatformAlertDialog(
///   context: context,
///   title: Text('Confirm'),
///   content: Text('Are you sure you want to continue?'),
///   actions: [
///     PlatformDialogAction(
///       child: Text('Cancel'),
///       onPressed: () => Navigator.pop(context),
///     ),
///     PlatformDialogAction(
///       child: Text('OK'),
///       onPressed: () => Navigator.pop(context),
///     ),
///   ],
/// )
/// ```
Future<T?> showPlatformAlertDialog<T>({
  required BuildContext context,
  PlatformDialogData? platformDialogData,
  MaterialDialogData? materialDialogData,
  PlatformDialogData? cupertinoDialogData,
  MaterialAlertDialogData? materialAlertDialogData,
  CupertinoAlertDialogData? cupertinoAlertDialogData,
  Widget? title,
  Widget? content,
  List<Widget>? actions,
  Key? key,
}) => _showBasePlatformDialog<T>(
  context: context,
  materialBuilder: (context) => AlertDialog(
    key: materialAlertDialogData?.widgetKey ?? key,
    title: materialAlertDialogData?.title ?? title,
    content: materialAlertDialogData?.content ?? content,
    actions: materialAlertDialogData?.actions ?? actions,
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
    scrollable: materialAlertDialogData?.scrollable ?? MaterialAlertDialogData.kDefaultScrollable,
  ),
  cupertinoBuilder: (context) => CupertinoAlertDialog(
    key: cupertinoAlertDialogData?.widgetKey ?? key,
    title: cupertinoAlertDialogData?.title ?? title,
    content: cupertinoAlertDialogData?.content ?? content,
    actions:
        cupertinoAlertDialogData?.actions ?? actions ?? CupertinoAlertDialogData.kDefaultActions,
    scrollController: cupertinoAlertDialogData?.scrollController,
    actionScrollController: cupertinoAlertDialogData?.actionScrollController,
    insetAnimationDuration:
        cupertinoAlertDialogData?.insetAnimationDuration ??
        CupertinoAlertDialogData.kDefaultInsetAnimationDuration,
    insetAnimationCurve:
        cupertinoAlertDialogData?.insetAnimationCurve ??
        CupertinoAlertDialogData.kDefaultInsetAnimationCurve,
  ),
  platformDialogData: platformDialogData,
  materialDialogData: materialDialogData,
  cupertinoDialogData: cupertinoDialogData,
);

/// A platform-adaptive dialog action button that renders TextButton on Android
/// and CupertinoDialogAction on iOS.
///
/// This widget automatically selects the appropriate button implementation based on the target platform:
/// - On Android: renders a Material Design TextButton
/// - On iOS: renders a CupertinoDialogAction
///
/// Default actions will have bold text but only on cupertino.
/// Destructive actions will be rendered in red text on cupertino and with a red filled background on material.
/// Using the `context` of [onPressed] allows to have a reference to the dialog context.
/// Customize the [ButtonTheme].colorScheme.error to change the color of destructive actions.
class PlatformAlertDialogActionButton extends PlatformWidgetKeyedBuilderBase {
  /// Callback when the action button is pressed.
  final ValueChanged<BuildContext>? onPressed;

  /// Whether this action represents a destructive action.
  ///
  /// Destructive actions are styled differently (typically red) to indicate they
  /// may cause data loss or other negative consequences.
  final bool isDestructiveAction;

  /// Whether this is the default action.
  ///
  /// Default actions may receive special styling or behavior.
  final bool isDefaultAction;

  /// Creates a new platform aware dialog action.
  ///
  /// Translates to a `TextButton` on material and a `CupertinoDialogAction` on cupertino.
  /// Default actions will have bold text but only on cupertino.
  /// Destructive actions will be rendered in red text on cupertino and with a red filled background on material.<br>
  /// Using the `context` of [onPressed] allows to have a reference to the dialog context.
  /// Customize the [ButtonTheme].colorScheme.error to change the color of destructive actions.
  const PlatformAlertDialogActionButton({
    required super.child,
    super.widgetKey,
    super.key,
    this.onPressed,
    this.isDestructiveAction = false,
    this.isDefaultAction = false,
  });

  @override
  Widget buildMaterial(BuildContext context) => TextButton(
    onPressed: () => onPressed?.call(context),
    style: !isDestructiveAction
        ? null
        : TextButton.styleFrom(
            foregroundColor: ButtonTheme.of(context).colorScheme?.error ?? Colors.red,
          ),
    child: child,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoDialogAction(
    onPressed: () => onPressed?.call(context),
    isDestructiveAction: isDestructiveAction,
    isDefaultAction: isDefaultAction,
    child: child,
  );
}

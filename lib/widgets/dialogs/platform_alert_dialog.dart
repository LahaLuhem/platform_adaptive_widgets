// ignore_for_file: prefer-match-file-name

part of 'platform_dialog.dart';

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

class PlatformAlertDialogActionButton extends PlatformWidgetKeyedBuilderBase {
  final ValueChanged<BuildContext>? onPressed;
  final bool isDestructiveAction;
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

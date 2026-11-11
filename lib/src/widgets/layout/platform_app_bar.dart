/// @docImport '/src/widgets/layout/platform_scaffold.dart';
library;

import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoActivityIndicator,
        CupertinoButton,
        CupertinoLocalizations,
        CupertinoNavigationBar,
        CupertinoSheetRoute,
        CupertinoTheme,
        ObstructingPreferredSizeWidget;
import 'package:flutter/semantics.dart' show SemanticsBinding;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show
        AppBar,
        CircularProgressIndicator,
        CloseButton,
        Colors,
        IconButton,
        IconButtonTheme,
        ModalBottomSheetRoute,
        TextButton,
        TextButtonTheme,
        Theme,
        kThemeChangeDuration;

import '/src/models/layout/platform_app_bar_data.dart';
import '/src/models/layout/platform_bar_action.dart';
import '/src/widgets/interaction/internal/disabled_semantics.dart';

/// `AppBar` on Material, `CupertinoNavigationBar` on Cupertino.
///
/// [materialAppBarData] and [cupertinoNavigationBarData] tune one side, [backgroundColor] included,
/// since Cupertino bars are often translucent where Material's are opaque.
///
/// It `implements` [PlatformAppBarData] rather than extending `PlatformWidgetBase`, since a scaffold's
/// bar slot wants a `PreferredSizeWidget`. So there's no `build`, just the 2 builders [PlatformScaffold]
/// picks between.
///
/// Guidelines: [M3 app bars](https://m3.material.io/components/app-bars/guidelines),
/// [HIG toolbars](https://developer.apple.com/design/human-interface-guidelines/toolbars).
///
/// Example:
/// {@example /example/lib/snippets/layout/platform_app_bar.dart#platform_app_bar}
class const PlatformAppBar({
  /// The bar's own key, since this isn't a widget.
  final Key? widgetKey,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialAppBarData materialAppBarData = const MaterialAppBarData(),

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoNavigationBarData cupertinoNavigationBarData = const CupertinoNavigationBarData(),

  final Widget? title,

  final Color? backgroundColor,

  /// Lets each bar add its own way out before the title: back, close or Cancel, or Material's drawer
  /// button. Either side's `leading` replaces it.
  final bool automaticallyImplyLeading = true,

  /// Each platform's own bar buttons, at the trailing edge. M3 asks for 2 at most on a phone, the HIG
  /// for few. `materialAppBarData.actions` or `cupertinoNavigationBarData.trailing` replace these and
  /// [primaryAction] on their side.
  final List<PlatformBarAction> actions = const [],

  /// The action that finishes the screen, like Done or Save. It goes last, and Cupertino sets its text
  /// semibold, as iOS does.
  final PlatformBarAction? primaryAction,

  /// Under the bar, usually tabs.
  final PreferredSizeWidget? bottom,
}) implements PlatformAppBarData {
  /// Creates a platform-adaptive app bar.
  this;

  @override
  PreferredSizeWidget materialBuilder(BuildContext context) => AppBar(
    key: widgetKey,
    leading:
        materialAppBarData.leading ??
        // AppBar swaps its back arrow for a close button only in a full-screen dialog.
        (automaticallyImplyLeading && ModalRoute.of(context) is ModalBottomSheetRoute
            ? const CloseButton()
            : null),
    title: title,
    backgroundColor: materialAppBarData.backgroundColor ?? backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: bottom,
    actions:
        materialAppBarData.actions ??
        [
          for (final action in actions) _MaterialBarAction(action, key: _keyOf(action)),
          if (primaryAction case final primary?) _MaterialBarAction(primary, key: _keyOf(primary)),
        ],
    automaticallyImplyActions: materialAppBarData.automaticallyImplyActions,
    flexibleSpace: materialAppBarData.flexibleSpace,
    elevation: materialAppBarData.elevation,
    scrolledUnderElevation: materialAppBarData.scrolledUnderElevation,
    notificationPredicate: materialAppBarData.notificationPredicate,
    shadowColor: materialAppBarData.shadowColor,
    surfaceTintColor: materialAppBarData.surfaceTintColor,
    shape: materialAppBarData.shape,
    foregroundColor: materialAppBarData.foregroundColor,
    iconTheme: materialAppBarData.iconTheme,
    actionsIconTheme: materialAppBarData.actionsIconTheme,
    primary: materialAppBarData.primary,
    centerTitle: materialAppBarData.centerTitle,
    excludeHeaderSemantics: materialAppBarData.excludeHeaderSemantics,
    titleSpacing: materialAppBarData.titleSpacing,
    toolbarOpacity: materialAppBarData.toolbarOpacity,
    bottomOpacity: materialAppBarData.bottomOpacity,
    toolbarHeight: materialAppBarData.toolbarHeight,
    leadingWidth: materialAppBarData.leadingWidth,
    toolbarTextStyle: materialAppBarData.toolbarTextStyle,
    titleTextStyle: materialAppBarData.titleTextStyle,
    systemOverlayStyle: materialAppBarData.systemOverlayStyle,
    forceMaterialTransparency: materialAppBarData.forceMaterialTransparency,
    useDefaultSemanticsOrder: materialAppBarData.useDefaultSemanticsOrder,
    clipBehavior: materialAppBarData.clipBehavior,
    actionsPadding: materialAppBarData.actionsPadding,
    animateColor: materialAppBarData.animateColor,
  );

  @override
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context) {
    final resolvedBackgroundColor = cupertinoNavigationBarData.backgroundColor ?? backgroundColor;
    final automaticallyImplyMiddle = cupertinoNavigationBarData.automaticallyImplyMiddle;
    final automaticBackgroundVisibility = cupertinoNavigationBarData.automaticBackgroundVisibility;
    final enableBackgroundFilterBlur = cupertinoNavigationBarData.enableBackgroundFilterBlur;
    final transitionBetweenRoutes = cupertinoNavigationBarData.transitionBetweenRoutes;
    final heroTag = cupertinoNavigationBarData.heroTag;
    final leading =
        cupertinoNavigationBarData.leading ??
        // cupertino_ui gives a full-screen dialog's bar a Cancel, but leaves a sheet's empty.
        (automaticallyImplyLeading && ModalRoute.of(context) is CupertinoSheetRoute
            ? _CupertinoBarAction(
                PlatformBarAction(
                  label: CupertinoLocalizations.of(context).cancelButtonLabel,
                  onPressed: () => Navigator.maybePop(context),
                ),
              )
            : null);
    final trailing =
        cupertinoNavigationBarData.trailing ??
        (actions.isEmpty && primaryAction == null
            ? null
            : Row(
                mainAxisSize: .min,
                // UIKit's gap between bar items.
                spacing: 8,
                children: [
                  for (final action in actions) _CupertinoBarAction(action, key: _keyOf(action)),
                  if (primaryAction case final primary?)
                    _CupertinoBarAction(primary, isPrimary: true, key: _keyOf(primary)),
                ],
              ));

    if (cupertinoNavigationBarData.large) {
      return heroTag == null
          ? CupertinoNavigationBar.large(
              key: widgetKey,
              largeTitle: title,
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              automaticallyImplyTitle: automaticallyImplyMiddle,
              previousPageTitle: cupertinoNavigationBarData.previousPageTitle,
              trailing: trailing,
              border: cupertinoNavigationBarData.border,
              backgroundColor: resolvedBackgroundColor,
              automaticBackgroundVisibility: automaticBackgroundVisibility,
              enableBackgroundFilterBlur: enableBackgroundFilterBlur,
              brightness: cupertinoNavigationBarData.brightness,
              padding: cupertinoNavigationBarData.padding,
              transitionBetweenRoutes: transitionBetweenRoutes,
              bottom: bottom,
            )
          : CupertinoNavigationBar.large(
              key: widgetKey,
              largeTitle: title,
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              automaticallyImplyTitle: automaticallyImplyMiddle,
              previousPageTitle: cupertinoNavigationBarData.previousPageTitle,
              trailing: trailing,
              border: cupertinoNavigationBarData.border,
              backgroundColor: resolvedBackgroundColor,
              automaticBackgroundVisibility: automaticBackgroundVisibility,
              enableBackgroundFilterBlur: enableBackgroundFilterBlur,
              brightness: cupertinoNavigationBarData.brightness,
              padding: cupertinoNavigationBarData.padding,
              transitionBetweenRoutes: transitionBetweenRoutes,
              bottom: bottom,
              heroTag: heroTag,
            );
    }

    return heroTag == null
        ? CupertinoNavigationBar(
            key: widgetKey,
            leading: leading,
            middle: title,
            backgroundColor: resolvedBackgroundColor,
            automaticallyImplyLeading: automaticallyImplyLeading,
            bottom: bottom,
            automaticallyImplyMiddle: automaticallyImplyMiddle,
            previousPageTitle: cupertinoNavigationBarData.previousPageTitle,
            trailing: trailing,
            border: cupertinoNavigationBarData.border,
            automaticBackgroundVisibility: automaticBackgroundVisibility,
            enableBackgroundFilterBlur: enableBackgroundFilterBlur,
            brightness: cupertinoNavigationBarData.brightness,
            padding: cupertinoNavigationBarData.padding,
            transitionBetweenRoutes: transitionBetweenRoutes,
          )
        : CupertinoNavigationBar(
            key: widgetKey,
            leading: leading,
            middle: title,
            backgroundColor: resolvedBackgroundColor,
            automaticallyImplyLeading: automaticallyImplyLeading,
            bottom: bottom,
            automaticallyImplyMiddle: automaticallyImplyMiddle,
            previousPageTitle: cupertinoNavigationBarData.previousPageTitle,
            trailing: trailing,
            border: cupertinoNavigationBarData.border,
            automaticBackgroundVisibility: automaticBackgroundVisibility,
            enableBackgroundFilterBlur: enableBackgroundFilterBlur,
            brightness: cupertinoNavigationBarData.brightness,
            padding: cupertinoNavigationBarData.padding,
            transitionBetweenRoutes: transitionBetweenRoutes,
            heroTag: heroTag,
          );
  }
}

class const _MaterialBarAction(final PlatformBarAction action, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => switch (action) {
    PlainBarAction(:final isEnabled, :final onPressed) => _MaterialBarButton(
      action,
      onPressed: !isEnabled ? null : onPressed,
    ),
    final DebouncedBarAction debouncedAction => _DebouncedBarAction(
      debouncedAction,
      swapStyle: _materialSwapStyle,
      buttonBuilder: (onPressed, swap) => _MaterialBarButton(
        action,
        onPressed: onPressed,
        swap: swap,
        // Built only here, so an app with no debounced action ships no spinner.
        spinner: !swap.hasSpinner ? null : _MaterialSpinner(isInTextButton: action.icon == null),
      ),
    ),
  };
}

// Each platform's own bar button, not a PlatformButton, which is sized to stand alone.
class const _MaterialBarButton(
  final PlatformBarAction action, {
  required final VoidCallback? onPressed,
  final _Swap? swap,
  final Widget? spinner,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icon = action.icon;
    final busySwap = swap;
    final content = icon ?? Text(action.label);
    final shownContent = busySwap == null
        ? content
        : _SwapContent(
            content,
            spinner: spinner,
            swap: busySwap,
            // An icon button names itself through its tooltip.
            semanticLabel: icon != null ? null : action.label,
          );

    return icon == null
        ? TextButton(
            onPressed: onPressed,
            // Material fades label colours between states, so a busy label keeps its own, not grey.
            style: busySwap != null && busySwap.isBusy
                ? TextButton.styleFrom(disabledForegroundColor: _textActionColour(context))
                : null,
            child: shownContent,
          )
        : IconButton(onPressed: onPressed, tooltip: action.label, icon: shownContent);
  }
}

Color _textActionColour(BuildContext context) =>
    TextButtonTheme.of(context).style?.foregroundColor?.resolve(const {}) ??
    Theme.of(context).colorScheme.primary;

class const _MaterialSpinner({required final bool isInTextButton}) extends StatelessWidget {
  // M3's smallest circular indicator, the size of the icon it stands in for.
  static const _size = 24.0;

  @override
  Widget build(BuildContext context) => CircularProgressIndicator(
    // M3 wants the content's own colour, with no track, not the grey of a disabled icon button.
    color: isInTextButton
        ? _textActionColour(context)
        : IconButtonTheme.of(context).style?.foregroundColor?.resolve(const {}) ??
              IconTheme.of(context).color,
    backgroundColor: Colors.transparent,
    constraints: .tight(const .square(_size)),
  );
}

class const _CupertinoBarAction(
  final PlatformBarAction action, {
  final bool isPrimary = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => switch (action) {
    PlainBarAction(:final isEnabled, :final onPressed) => _CupertinoBarButton(
      action,
      isPrimary: isPrimary,
      onPressed: !isEnabled ? null : onPressed,
    ),
    final DebouncedBarAction debouncedAction => _DebouncedBarAction(
      debouncedAction,
      swapStyle: _cupertinoSwapStyle,
      buttonBuilder: (onPressed, swap) => _CupertinoBarButton(
        action,
        isPrimary: isPrimary,
        onPressed: onPressed,
        swap: swap,
        // Built only here, so an app with no debounced action ships no spinner.
        spinner: !swap.hasSpinner ? null : const _CupertinoSpinner(),
      ),
    ),
  };
}

class const _CupertinoBarButton(
  final PlatformBarAction action, {
  required final VoidCallback? onPressed,
  final bool isPrimary = false,
  final _Swap? swap,
  final Widget? spinner,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icon = action.icon;
    final busySwap = swap;
    final content = icon == null
        ? Text(action.label, style: !isPrimary ? null : const TextStyle(fontWeight: .w600))
        // The label names it, in place of anything the icon says about itself.
        : Semantics(label: action.label, excludeSemantics: true, child: icon);

    return DisabledSemantics(
      isEnabled: onPressed != null,
      child: CupertinoButton(
        // Flush, like cupertino_ui's own bar buttons. Any padding squeezes the content in a 44pt bar.
        padding: .zero,
        onPressed: onPressed,
        child: busySwap == null
            ? content
            : _SwapContent(content, spinner: spinner, swap: busySwap, semanticLabel: action.label),
      ),
    );
  }
}

class const _CupertinoSpinner() extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // A plain CupertinoButton's colour, not the grey of a busy, disabled one.
      CupertinoActivityIndicator(color: CupertinoTheme.of(context).primaryColor);
}

typedef _Swap = ({
  AnimatedSwitcherTransitionBuilder transitionBuilder,
  Animation<double> content,
  Animation<double> spinner,
  bool hasSpinner,
  bool isBusy,
});

typedef _SwapStyle = ({
  Duration duration,
  Curve curve,
  Duration reverseDuration,
  Curve reverseCurve,
});

// Material's own buttons change state over this.
const _SwapStyle _materialSwapStyle = (
  duration: kThemeChangeDuration,
  curve: Curves.fastOutSlowIn,
  reverseDuration: kThemeChangeDuration,
  reverseCurve: Curves.fastOutSlowIn,
);

// CupertinoButton's press and release fades, which it keeps private.
const _SwapStyle _cupertinoSwapStyle = (
  duration: Duration(milliseconds: 120),
  curve: Curves.easeInOutCubicEmphasized,
  reverseDuration: Duration(milliseconds: 180),
  reverseCurve: Curves.easeOutCubic,
);

// The content keeps sizing the action, and screen readers keep its label, whatever the transition does.
class const _SwapContent(
  final Widget content, {
  required final Widget? spinner,
  required final _Swap swap,
  required final String? semanticLabel,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    child: ExcludeSemantics(
      child: Stack(
        alignment: .center,
        clipBehavior: .none,
        children: [
          swap.transitionBuilder(content, swap.content),
          if (spinner case final busySpinner?)
            Positioned(child: swap.transitionBuilder(busySpinner, swap.spinner)),
        ],
      ),
    ),
  );
}

class const _DebouncedBarAction(
  final DebouncedBarAction action, {
  required final _SwapStyle swapStyle,
  required final Widget Function(VoidCallback? onPressed, _Swap swap) buttonBuilder,
}) extends StatefulWidget {
  @override
  State<_DebouncedBarAction> createState() => _DebouncedBarActionState();
}

class _DebouncedBarActionState()
    extends State<_DebouncedBarAction>
    with SingleTickerProviderStateMixin {
  // 0 shows the content, 1 the spinner. Without a transition it jumps between the 2.
  late final _swapAnimationController = AnimationController(vsync: this);
  late final _contentSwapAnimation = ReverseAnimation(_swapAnimationController);
  // Equal records don't notify, so the button rebuilds as a swap starts and settles, not every frame.
  final _swapStageNotifier = ValueNotifier((isBusy: false, hasSpinner: false));
  // Set from the first tap, before anything shows, so a quick 2nd tap is dropped too.
  var _isRunning = false;
  Timer? _busyTimer;

  // Read as each swap starts, so a setting switched on while the app runs counts too.
  bool get _asksForLessMotion =>
      SemanticsBinding.instance.disableAnimations ||
      SemanticsBinding.instance.accessibilityFeatures.reduceMotion;

  @override
  void initState() {
    super.initState();

    _swapAnimationController.addStatusListener(
      // Busy once the spinner has taken over, so the content fades out in its own colour.
      (status) =>
          _swapStageNotifier.value = (isBusy: status.isCompleted, hasSpinner: !status.isDismissed),
    );
  }

  @override
  void dispose() {
    _busyTimer?.cancel();
    _swapAnimationController.dispose();
    _swapStageNotifier.dispose();

    super.dispose();
  }

  void _onPressed() {
    if (!_isRunning) unawaited(_run());
  }

  // Left uncaught, so a failure lands where an unawaited future's would.
  Future<void> _run() async {
    _isRunning = true;
    _busyTimer = Timer(kBarActionBusyDelay, () => _swapTo(isBusy: true));
    try {
      await widget.action.onPressed();
    } finally {
      _busyTimer?.cancel();
      _isRunning = false;
      // The work may have closed the screen, and the swap with it.
      if (mounted) _swapTo(isBusy: false);
    }
  }

  void _swapTo({required bool isBusy}) {
    final style = widget.swapStyle;
    if (widget.action.transitionBuilder == null || _asksForLessMotion) {
      _swapAnimationController.value = isBusy ? 1 : 0;
    } else {
      unawaited(
        isBusy
            ? _swapAnimationController.animateTo(1, duration: style.duration, curve: style.curve)
            : _swapAnimationController.animateBack(
                0,
                duration: style.reverseDuration,
                curve: style.reverseCurve,
              ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _swapStageNotifier,
    builder: (_, stage, _) =>
        widget.buttonBuilder(!widget.action.isEnabled || stage.isBusy ? null : _onPressed, (
          transitionBuilder:
              widget.action.transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder,
          content: _contentSwapAnimation,
          spinner: _swapAnimationController,
          hasSpinner: stage.hasSpinner,
          isBusy: stage.isBusy,
        )),
  );
}

// Keeps a running action's state with it as the actions before it change. Plain ones stay unkeyed,
// so 2 can share a label.
Key? _keyOf(PlatformBarAction action) =>
    action is! DebouncedBarAction ? null : ValueKey(action.label);

/// @docImport '/src/widgets/layout/platform_scaffold.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoButton,
        CupertinoLocalizations,
        CupertinoNavigationBar,
        CupertinoSheetRoute,
        ObstructingPreferredSizeWidget;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show AppBar, CloseButton, IconButton, ModalBottomSheetRoute, TextButton;

import '/src/models/layout/platform_app_bar_data.dart';
import '/src/models/layout/platform_bar_action.dart';
import '/src/widgets/interaction/disabled_semantics.dart';

/// `AppBar` on Material, `CupertinoNavigationBar` on Cupertino.
///
/// Per-platform tuning lives in [materialAppBarData] / [cupertinoNavigationBarData], which can also
/// override [backgroundColor] on one side alone. Worth doing, since Cupertino nav bars tend to be translucent
/// where Material's are opaque.
///
/// The odd one out in this package: it `implements` [PlatformAppBarData] instead of extending `PlatformWidgetBase`,
/// because a scaffold's bar slot wants a `PreferredSizeWidget` and a plain `StatelessWidget` isn't one.
/// So there's no `build` here, just the 2 builders [PlatformScaffold] picks between.
///
/// Guidelines: [M3 app bars](https://m3.material.io/components/app-bars/guidelines),
/// [HIG toolbars](https://developer.apple.com/design/human-interface-guidelines/toolbars).
///
/// Example:
/// {@example /example/lib/snippets/layout/platform_app_bar.dart#platform_app_bar}
class const PlatformAppBar({
  /// Goes on the bar itself, since this isn't a widget with a [Key] of its own.
  final Key? widgetKey,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialAppBarData? materialAppBarData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoNavigationBarData? cupertinoNavigationBarData,

  final Widget? title,

  final Color? backgroundColor,

  /// Lets each bar add its own way out before the title: back, close or Cancel in a full-screen dialog or a
  /// sheet, or Material's drawer button. `materialAppBarData.leading` or `cupertinoNavigationBarData.leading`
  /// take its place on their side.
  final bool automaticallyImplyLeading = true,

  /// At the trailing edge, as each platform's own bar buttons. M3 asks for 2 at most on a phone, the HIG
  /// for few. Set, `materialAppBarData.actions` or `cupertinoNavigationBarData.trailing` replace these and
  /// [primaryAction] on their side.
  final List<PlatformBarAction> actions = const [],

  /// The action that finishes the screen, like Done or Save. It goes last, at the trailing edge, and
  /// Cupertino draws its text semibold, as iOS does.
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
        materialAppBarData?.leading ??
        // AppBar swaps its back arrow for a close button only in a full-screen dialog.
        (automaticallyImplyLeading && ModalRoute.of(context) is ModalBottomSheetRoute
            ? const CloseButton()
            : null),
    title: title,
    backgroundColor: materialAppBarData?.backgroundColor ?? backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: bottom,
    actions:
        materialAppBarData?.actions ??
        [
          for (final action in actions) _MaterialBarAction(action),
          if (primaryAction case final primary?) _MaterialBarAction(primary),
        ],
    automaticallyImplyActions:
        materialAppBarData?.automaticallyImplyActions ??
        MaterialAppBarData.kAutomaticallyImplyActions,
    flexibleSpace: materialAppBarData?.flexibleSpace,
    elevation: materialAppBarData?.elevation,
    scrolledUnderElevation: materialAppBarData?.scrolledUnderElevation,
    notificationPredicate:
        materialAppBarData?.notificationPredicate ??
        MaterialAppBarData.kDefaultScrollNotificationPredicate,
    shadowColor: materialAppBarData?.shadowColor,
    surfaceTintColor: materialAppBarData?.surfaceTintColor,
    shape: materialAppBarData?.shape,
    foregroundColor: materialAppBarData?.foregroundColor,
    iconTheme: materialAppBarData?.iconTheme,
    actionsIconTheme: materialAppBarData?.actionsIconTheme,
    primary: materialAppBarData?.primary ?? MaterialAppBarData.kDefaultPrimary,
    centerTitle: materialAppBarData?.centerTitle,
    excludeHeaderSemantics:
        materialAppBarData?.excludeHeaderSemantics ?? MaterialAppBarData.kExcludeHeaderSemantics,
    titleSpacing: materialAppBarData?.titleSpacing,
    toolbarOpacity: materialAppBarData?.toolbarOpacity ?? MaterialAppBarData.kToolbarOpacity,
    bottomOpacity: materialAppBarData?.bottomOpacity ?? MaterialAppBarData.kBottomOpacity,
    toolbarHeight: materialAppBarData?.toolbarHeight,
    leadingWidth: materialAppBarData?.leadingWidth,
    toolbarTextStyle: materialAppBarData?.toolbarTextStyle,
    titleTextStyle: materialAppBarData?.titleTextStyle,
    systemOverlayStyle: materialAppBarData?.systemOverlayStyle,
    forceMaterialTransparency:
        materialAppBarData?.forceMaterialTransparency ??
        MaterialAppBarData.kForceMaterialTransparency,
    useDefaultSemanticsOrder:
        materialAppBarData?.useDefaultSemanticsOrder ??
        MaterialAppBarData.kUseDefaultSemanticsOrder,
    clipBehavior: materialAppBarData?.clipBehavior,
    actionsPadding: materialAppBarData?.actionsPadding,
    animateColor: materialAppBarData?.animateColor ?? MaterialAppBarData.kAnimateColor,
  );

  @override
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context) {
    // Resolved once, since every branch below passes the same set.
    final resolvedBackgroundColor = cupertinoNavigationBarData?.backgroundColor ?? backgroundColor;
    final automaticallyImplyMiddle =
        cupertinoNavigationBarData?.automaticallyImplyMiddle ??
        CupertinoNavigationBarData.kAutomaticallyImplyMiddle;
    final automaticBackgroundVisibility =
        cupertinoNavigationBarData?.automaticBackgroundVisibility ??
        CupertinoNavigationBarData.kAutomaticBackgroundVisibility;
    final enableBackgroundFilterBlur =
        cupertinoNavigationBarData?.enableBackgroundFilterBlur ??
        CupertinoNavigationBarData.kEnableBackgroundFilterBlur;
    final transitionBetweenRoutes =
        cupertinoNavigationBarData?.transitionBetweenRoutes ??
        CupertinoNavigationBarData.kTransitionBetweenRoutes;
    // Promoted to non-null inside the branches below, so no force-unwrap is needed there.
    final heroTag = cupertinoNavigationBarData?.heroTag;
    final leading =
        cupertinoNavigationBarData?.leading ??
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
        cupertinoNavigationBarData?.trailing ??
        (actions.isEmpty && primaryAction == null
            ? null
            : Row(
                mainAxisSize: .min,
                // UIKit's gap between bar items.
                spacing: 8,
                children: [
                  for (final action in actions) _CupertinoBarAction(action),
                  if (primaryAction case final primary?)
                    _CupertinoBarAction(primary, isPrimary: true),
                ],
              ));

    if (cupertinoNavigationBarData?.large ?? CupertinoNavigationBarData.kLarge) {
      return heroTag == null
          ? CupertinoNavigationBar.large(
              key: widgetKey,
              largeTitle: title,
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              automaticallyImplyTitle: automaticallyImplyMiddle,
              previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
              trailing: trailing,
              border: cupertinoNavigationBarData?.border,
              backgroundColor: resolvedBackgroundColor,
              automaticBackgroundVisibility: automaticBackgroundVisibility,
              enableBackgroundFilterBlur: enableBackgroundFilterBlur,
              brightness: cupertinoNavigationBarData?.brightness,
              padding: cupertinoNavigationBarData?.padding,
              transitionBetweenRoutes: transitionBetweenRoutes,
              bottom: bottom,
            )
          : CupertinoNavigationBar.large(
              key: widgetKey,
              largeTitle: title,
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              automaticallyImplyTitle: automaticallyImplyMiddle,
              previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
              trailing: trailing,
              border: cupertinoNavigationBarData?.border,
              backgroundColor: resolvedBackgroundColor,
              automaticBackgroundVisibility: automaticBackgroundVisibility,
              enableBackgroundFilterBlur: enableBackgroundFilterBlur,
              brightness: cupertinoNavigationBarData?.brightness,
              padding: cupertinoNavigationBarData?.padding,
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
            previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
            trailing: trailing,
            border: cupertinoNavigationBarData?.border,
            automaticBackgroundVisibility: automaticBackgroundVisibility,
            enableBackgroundFilterBlur: enableBackgroundFilterBlur,
            brightness: cupertinoNavigationBarData?.brightness,
            padding: cupertinoNavigationBarData?.padding,
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
            previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
            trailing: trailing,
            border: cupertinoNavigationBarData?.border,
            automaticBackgroundVisibility: automaticBackgroundVisibility,
            enableBackgroundFilterBlur: enableBackgroundFilterBlur,
            brightness: cupertinoNavigationBarData?.brightness,
            padding: cupertinoNavigationBarData?.padding,
            transitionBetweenRoutes: transitionBetweenRoutes,
            heroTag: heroTag,
          );
  }
}

// Each platform's own bar button, not a PlatformButton, which is sized to stand alone.
class const _MaterialBarAction(final PlatformBarAction action) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onPressed = action.isEnabled ? action.onPressed : null;
    final icon = action.icon;

    return icon == null
        ? TextButton(onPressed: onPressed, child: Text(action.label))
        : IconButton(onPressed: onPressed, tooltip: action.label, icon: icon);
  }
}

class const _CupertinoBarAction(final PlatformBarAction action, {final bool isPrimary = false})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icon = action.icon;

    return DisabledSemantics(
      isEnabled: action.isEnabled,
      child: CupertinoButton(
        // Flush, like cupertino_ui's own bar buttons. Any padding squeezes the content in a 44pt bar.
        padding: EdgeInsets.zero,
        onPressed: action.isEnabled ? action.onPressed : null,
        child: icon == null
            ? Text(action.label, style: isPrimary ? const TextStyle(fontWeight: .w600) : null)
            // The label names it, in place of anything the icon says about itself.
            : Semantics(label: action.label, excludeSemantics: true, child: icon),
      ),
    );
  }
}

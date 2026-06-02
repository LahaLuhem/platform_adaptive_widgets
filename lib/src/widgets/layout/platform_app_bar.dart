/// @docImport '/src/widgets/layout/platform_scaffold.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoNavigationBar, ObstructingPreferredSizeWidget;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show AppBar;

import '/src/models/layout/platform_app_bar_data.dart';

/// A platform-adaptive app bar — Material `AppBar` on Android,
/// `CupertinoNavigationBar` on iOS.
///
/// Shared content (`title`, `leading`, `bottom`, `automaticallyImplyLeading`,
/// `widgetKey`) is functional and lives flat on this widget, single source of
/// truth. The only per-platform-overridable property is [backgroundColor]
/// (shared-visual — iOS nav bars are often translucent, Android opaque). Pass
/// [materialAppBarData] / [cupertinoNavigationBarData] for the rest of each
/// platform's surface.
///
/// Unlike the rest of the package, `PlatformAppBar` `implements`
/// [PlatformAppBarData] rather than extending `PlatformWidgetBase`: a scaffold's
/// app-bar slot requires a `PreferredSizeWidget` (Material) /
/// `ObstructingPreferredSizeWidget` (Cupertino), neither of which a plain
/// `StatelessWidget` satisfies. So instead of a `build` method it exposes
/// [materialBuilder] / [cupertinoBuilder]; [PlatformScaffold] calls the matching
/// one for the target platform.
///
/// Example:
/// ```dart
/// PlatformAppBar(
///   title: const Text('My App'),
///   leading: IconButton(
///     icon: const Icon(Icons.menu),
///     onPressed: () => Scaffold.of(context).openDrawer(),
///   ),
/// )
/// ```
class PlatformAppBar implements PlatformAppBarData {
  /// Optional key for the app bar widget.
  final Key? widgetKey;

  /// Widget to display before the title.
  ///
  /// Typically used for navigation or menu icons.
  final Widget? leading;

  /// The primary title of the app bar.
  final Widget? title;

  /// Widget to display below the app bar.
  ///
  /// Typically used for tabs or other supplementary content.
  final PreferredSizeWidget? bottom;

  /// Background color of the app bar. Per-platform override via
  /// [MaterialAppBarData.backgroundColor] / [CupertinoNavigationBarData.backgroundColor].
  final Color? backgroundColor;

  /// Whether to automatically imply a leading widget.
  ///
  /// If true, a back button is automatically added when appropriate.
  final bool automaticallyImplyLeading;

  /// Material-specific app bar data.
  final MaterialAppBarData? materialAppBarData;

  /// Cupertino-specific navigation bar data.
  final CupertinoNavigationBarData? cupertinoNavigationBarData;

  /// Creates a platform-adaptive app bar.
  const PlatformAppBar({
    this.widgetKey,
    this.materialAppBarData,
    this.cupertinoNavigationBarData,
    this.title,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  @override
  PreferredSizeWidget materialBuilder(BuildContext context) => AppBar(
    key: widgetKey,
    leading: leading,
    title: title,
    backgroundColor: materialAppBarData?.backgroundColor ?? backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: bottom,
    actions: materialAppBarData?.actions,
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
    // Shared values resolved once — both the standard/large variants and the
    // heroTag null/non-null sub-branches below pass the identical set.
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
    // Promoted to non-null inside the `heroTag != null` branches below, so the
    // constructor calls pass it without a force-unwrap.
    final heroTag = cupertinoNavigationBarData?.heroTag;

    // The .large variant renders iOS's expanded, left-aligned large title:
    // `title` becomes the `largeTitle` and `automaticallyImplyMiddle` drives the
    // ctor's `automaticallyImplyTitle`. Everything else matches the standard
    // bar. iOS-only — there is no static large-title AppBar on Material.
    if (cupertinoNavigationBarData?.large ?? CupertinoNavigationBarData.kLarge) {
      return heroTag == null
          // No heroTag: omit the param so CupertinoNavigationBar applies its own
          // default tag (a private detail we can't reference to substitute).
          // ignore: prefer-define-hero-tag
          ? CupertinoNavigationBar.large(
              key: widgetKey,
              largeTitle: title,
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              automaticallyImplyTitle: automaticallyImplyMiddle,
              previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
              trailing: cupertinoNavigationBarData?.trailing,
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
              trailing: cupertinoNavigationBarData?.trailing,
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
        // Covered in the next declaration
        // ignore: prefer-define-hero-tag
        ? CupertinoNavigationBar(
            key: widgetKey,
            leading: leading,
            middle: title,
            backgroundColor: resolvedBackgroundColor,
            automaticallyImplyLeading: automaticallyImplyLeading,
            bottom: bottom,
            automaticallyImplyMiddle: automaticallyImplyMiddle,
            previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
            trailing: cupertinoNavigationBarData?.trailing,
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
            trailing: cupertinoNavigationBarData?.trailing,
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

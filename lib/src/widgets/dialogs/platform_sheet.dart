// Named after its function, not the private guard below.
// ignore_for_file: prefer-match-file-name

/// @docImport '/src/widgets/dialogs/platform_dialog.dart';
library;

import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart' show showCupertinoSheet;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show AppBarTheme, Colors, showModalBottomSheet;

import '/src/models/dialogs/platform_unsaved_changes.dart';
import '/src/models/layout/platform_app_bar_data.dart';
import '/src/utils/design_language.dart';
import '/src/widgets/layout/platform_app_bar.dart';
import '/src/widgets/layout/platform_scaffold.dart';
import 'platform_destructive_confirm.dart';

/// Shows content in a sheet: M3's modal bottom sheet on Material, cupertino_ui's sheet on Cupertino. It's
/// for extra content and short tasks, like a small form. A long or multistep task wants
/// [showPlatformFullscreenDialog].
///
/// You hand over the bar and the body, and the package lays them out the way each platform's sheet does,
/// lifted above the keyboard. Each bar adds its own way out, M3's close X or iOS's Cancel. Leave
/// [appBarBuilder] out and iOS still gets a bar with Cancel, while Android shows M3's plain sheet, closed
/// by its scrim, a swipe or Back.
///
/// Both builders get the sheet's own context, so a Save in the bar closes this sheet whichever navigator
/// opened it. A body that can outgrow the screen should scroll.
///
/// Name a confirming action by what it does, like Save or Create, as M3 asks of a full-screen dialog. iOS
/// draws it semibold either way.
///
/// Pass [unsavedChanges] and closing the sheet asks first, with an action sheet on iOS and a dialog on
/// Android. A Save that closes it through `Navigator.pop` doesn't ask.
///
/// Returns what the bar's action pops, or null for any other way out.
///
/// Known Flutter gaps:
///
/// - iOS has one height, close to the HIG's large one, and no medium
///   ([flutter/flutter#169832](https://github.com/flutter/flutter/issues/169832)).
/// - On Material, long content opens up to the full screen, where M3 opens at half and pulls to full
///   ([flutter/flutter#195041](https://github.com/flutter/flutter/issues/195041)).
/// - A sheet with [unsavedChanges] can't be swiped closed, since a swipe wouldn't ask
///   ([flutter/flutter#171878](https://github.com/flutter/flutter/issues/171878) on iOS,
///   [flutter/flutter#152120](https://github.com/flutter/flutter/issues/152120) on Android).
///
/// Guidelines: [M3 bottom sheets](https://m3.material.io/components/bottom-sheets/guidelines),
/// [HIG sheets](https://developer.apple.com/design/human-interface-guidelines/sheets).
Future<T?> showPlatformSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  PlatformAppBarData Function(BuildContext context)? appBarBuilder,
  PlatformUnsavedChanges? unsavedChanges,
  Color? backgroundColor,
  RouteSettings? routeSettings,
}) => switch (designLanguage) {
  .material => showModalBottomSheet<T>(
    context: context,
    // Sized to its content, up to the full screen below the status bar.
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    // A handle moves a sheet between its heights, and this one has a single height.
    showDragHandle: false,
    enableDrag: unsavedChanges == null,
    backgroundColor: backgroundColor,
    routeSettings: routeSettings,
    builder: (context) => _UnsavedChangesScope(
      unsavedChanges,
      child: Padding(
        // material_ui's sheet stays put when the keyboard opens.
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          mainAxisSize: .min,
          children: [
            if (appBarBuilder case final bar?)
              AppBarTheme(
                // On the sheet's own color and rounded corners, rather than a band of the bar's.
                data: AppBarTheme.of(context).copyWith(backgroundColor: Colors.transparent),
                child: bar(context).materialBuilder(context),
              ),
            Flexible(child: builder(context)),
          ],
        ),
      ),
    ),
  ),
  .cupertino => showCupertinoSheet<T>(
    context: context,
    settings: routeSettings,
    enableDrag: unsavedChanges == null,
    // Not handed the sheet's scroll controller: cupertino_ui's scroll path ignores `enableDrag`, so a
    // guarded sheet could still close through a list.
    scrollableBuilder: (context, _) => _UnsavedChangesScope(
      unsavedChanges,
      child: PlatformScaffold(
        // Without a bar, a swipe would be the only way out.
        appBarData: appBarBuilder?.call(context) ?? const PlatformAppBar(),
        backgroundColor: backgroundColor,
        body: builder(context),
      ),
    ),
  ),
};

class const _UnsavedChangesScope(
  final PlatformUnsavedChanges? unsavedChanges, {
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unsavedChanges = this.unsavedChanges;

    return unsavedChanges == null
        ? child
        : PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) unawaited(_close(context, unsavedChanges));
            },
            child: child,
          );
  }

  static Future<void> _close(BuildContext context, PlatformUnsavedChanges unsavedChanges) async {
    if (unsavedChanges.hasChanges() &&
        !await showPlatformDestructiveConfirm(
          context: context,
          message: unsavedChanges.message,
          confirmLabel: unsavedChanges.discardLabel,
        )) {
      return;
    }

    if (context.mounted) Navigator.pop(context);
  }
}

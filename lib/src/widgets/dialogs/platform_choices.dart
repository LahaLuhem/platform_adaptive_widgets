/// @docImport '/src/widgets/dialogs/platform_confirm.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoActionSheet, CupertinoActionSheetAction, CupertinoLocalizations;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ListTile, Theme;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_choice.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';
import '/src/utils/design_language.dart';
import 'sheet_routes.dart';

/// Lines the header up with the rows' text.
const _kMaterialChoicesHeaderPadding = EdgeInsetsDirectional.fromSTEB(16, 16, 24, 8);

/// Offers a few choices and answers with the picked one's [PlatformChoice.value], or null if the
/// person backs out. An action sheet on Cupertino, a bottom sheet of rows on Material.
///
/// Leave Cancel out of [choices], the package handles backing out. For a single choice, use
/// [showPlatformConfirm]. Keep the list short.
Future<T?> showPlatformChoices<T extends Object>({
  required BuildContext context,
  required List<PlatformChoice<T>> choices,
  String? title,
  String? message,
  Offset? anchorPoint,
  Color? barrierColor,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  ScrollController? scrollController,
  MaterialModalBottomSheetData? materialModalBottomSheetData,
  CupertinoModalPopupData? cupertinoModalPopupData,
}) {
  assert(
    choices.length >= 2,
    'Pass at least 2 choices. For a single one, use showPlatformConfirm.',
  );

  return switch (designLanguage) {
    .material => _showMaterialChoices(
      context: context,
      choices: choices,
      title: title,
      message: message,
      scrollController: scrollController,
      materialModalBottomSheetData: materialModalBottomSheetData,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
    ),
    .cupertino => _showCupertinoChoices(
      context: context,
      choices: choices,
      title: title,
      message: message,
      scrollController: scrollController,
      cupertinoModalPopupData: cupertinoModalPopupData,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
    ),
  };
}

Future<T?> _showMaterialChoices<T extends Object>({
  required BuildContext context,
  required List<PlatformChoice<T>> choices,
  required String? title,
  required String? message,
  required ScrollController? scrollController,
  required MaterialModalBottomSheetData? materialModalBottomSheetData,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
}) => showMaterialSheetRoute(
  context: context,
  builder: (context) {
    final themeData = Theme.of(context);

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        if (title != null || message != null)
          Padding(
            padding: _kMaterialChoicesHeaderPadding,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                if (title != null) Text(title, style: themeData.textTheme.titleMedium),
                if (message != null)
                  Text(
                    message,
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      color: themeData.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        Flexible(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: [
              for (final choice in choices)
                ListTile(
                  title: Text(choice.label),
                  onTap: () => Navigator.maybeOf(context)?.pop(choice.value),
                ),
            ],
          ),
        ),
      ],
    );
  },
  materialModalBottomSheetData: materialModalBottomSheetData,
  anchorPoint: anchorPoint,
  barrierColor: barrierColor,
  // With no Cancel row, a tap outside is the way out.
  barrierDismissible: true,
  routeSettings: routeSettings,
  useRootNavigator: useRootNavigator,
  requestFocus: requestFocus,
);

Future<T?> _showCupertinoChoices<T extends Object>({
  required BuildContext context,
  required List<PlatformChoice<T>> choices,
  required String? title,
  required String? message,
  required ScrollController? scrollController,
  required CupertinoModalPopupData? cupertinoModalPopupData,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
}) => showCupertinoPopupRoute(
  context: context,
  builder: (context) => CupertinoActionSheet(
    title: title == null ? null : Text(title),
    message: message == null ? null : Text(message),
    actions: [
      // The HIG puts destructive choices on top.
      for (final choice in [
        ...choices.where((choice) => choice.actionKind != .normal),
        ...choices.where((choice) => choice.actionKind == .normal),
      ])
        CupertinoActionSheetAction(
          isDestructiveAction: choice.actionKind != .normal,
          onPressed: () => Navigator.maybeOf(context)?.pop(choice.value),
          child: Text(choice.label),
        ),
    ],
    actionScrollController: scrollController,
    cancelButton: CupertinoActionSheetAction(
      // iOS bolds its own Cancel, cupertino_ui doesn't unless asked.
      isDefaultAction: true,
      onPressed: () => Navigator.maybeOf(context)?.pop(),
      child: Text(CupertinoLocalizations.of(context).cancelButtonLabel),
    ),
  ),
  cupertinoModalPopupData: cupertinoModalPopupData,
  anchorPoint: anchorPoint,
  barrierColor: barrierColor,
  barrierDismissible: true,
  routeSettings: routeSettings,
  useRootNavigator: useRootNavigator,
  requestFocus: requestFocus,
);

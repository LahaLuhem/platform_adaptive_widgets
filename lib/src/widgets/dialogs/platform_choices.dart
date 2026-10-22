/// @docImport '/src/widgets/dialogs/platform_confirm.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ListTile, Theme;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_choice.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';
import '/src/utils/design_language.dart';
import 'cupertino_choices_sheet.dart';
import 'sheet_routes.dart';

/// Lines the header up with the rows' text.
const _kMaterialChoicesHeaderPadding = EdgeInsetsDirectional.fromSTEB(16, 16, 24, 8);

/// Offers a few choices and answers with the picked one's [PlatformChoice.value], or null if the
/// person backs out. An action sheet on Cupertino, a bottom sheet of rows on Material.
///
/// Leave Cancel out of [choices], the package handles backing out. For a single choice, use
/// [showPlatformConfirm]. Keep it short. Choices show in the set's order, except that iOS moves
/// destructive ones to the top.
///
/// Known Flutter gaps:
///
/// - Desktop gets a bottom sheet, since Flutter has no side sheet yet
///   ([flutter/flutter#119328](https://github.com/flutter/flutter/issues/119328)).
/// - On Material a long list stops at 9/16 of the screen, where M3 opens at half and pulls to full
///   ([flutter/flutter#195041](https://github.com/flutter/flutter/issues/195041)).
/// - On iPad and Mac the action sheet spans the window
///   ([flutter/flutter#195042](https://github.com/flutter/flutter/issues/195042)).
/// - Screen readers hear "Alert", untranslated
///   ([flutter/flutter#195019](https://github.com/flutter/flutter/issues/195019)).
///
/// Guidelines: [M3 bottom sheets](https://m3.material.io/components/bottom-sheets/guidelines),
/// [HIG action sheets](https://developer.apple.com/design/human-interface-guidelines/action-sheets#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_choices.dart#platform_choices}
Future<T?> showPlatformChoices<T extends Object>({
  required BuildContext context,
  required Set<PlatformChoice<T>> choices,
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
  assert(
    choices.map((choice) => choice.value).toSet().length == choices.length,
    'Give each choice its own value, or the answer cannot tell them apart.',
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
    .cupertino => showCupertinoChoicesSheet(
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
  required Set<PlatformChoice<T>> choices,
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

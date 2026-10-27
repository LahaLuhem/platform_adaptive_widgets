/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_choices.dart';
/// @docImport '/src/widgets/dialogs/platform_sheet.dart';
library;

import 'package:flutter/widgets.dart';

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';
import '/src/utils/design_language.dart';
import 'sheet_routes.dart';

/// Shows a modal that slides up from the bottom, [showModalBottomSheet] on Material and
/// [showCupertinoModalPopup] on Cupertino, with nothing added around your content. Content or a short task
/// fits [showPlatformSheet] instead, and an action sheet [showPlatformChoices].
///
/// Material's [showModalBottomSheet] still paints a sheet, which you can flatten with a transparent
/// `backgroundColor` on [materialModalBottomSheetData], while Cupertino's route paints nothing. That's
/// upstream's doing. What you still get over calling the 2 directly is the dispatch and each platform's own
/// transition.
///
/// Either pass [builder] for content shared across both, or pass [materialBuilder] and [cupertinoBuilder]
/// together. Mixing the 2 trips an assert.
///
/// Guidelines: [M3 bottom sheets](https://m3.material.io/components/bottom-sheets/guidelines),
/// [HIG sheets](https://developer.apple.com/design/human-interface-guidelines/sheets#Best-practices).
Future<T?> showPlatformRawModalBottomSheet<T>({
  required BuildContext context,
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
  Offset? anchorPoint,
  Color? barrierColor,
  bool barrierDismissible = kDefaultModalBottomSheetBarrierDismissible,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialModalBottomSheetData? materialModalBottomSheetData,
  CupertinoModalPopupData? cupertinoModalPopupData,
}) {
  _assertBuilderInvariant(
    hasBuilder: builder != null,
    hasMaterialBuilder: materialBuilder != null,
    hasCupertinoBuilder: cupertinoBuilder != null,
  );

  return switch (designLanguage) {
    .material => showMaterialSheetRoute(
      context: context,
      builder: materialBuilder ?? builder!,
      materialModalBottomSheetData: materialModalBottomSheetData,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
    ),
    .cupertino => showCupertinoPopupRoute(
      context: context,
      // Raw: no CupertinoPopupSurface wrap, the caller owns the surface.
      builder: cupertinoBuilder ?? builder!,
      cupertinoModalPopupData: cupertinoModalPopupData,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
    ),
  };
}

/// Takes booleans rather than the builders themselves. 2 function-typed `material*`/`cupertino*` params
/// would trip the AOT-pruning guard in `test/aot_pruning_regression_test.dart`.
void _assertBuilderInvariant({
  required bool hasBuilder,
  required bool hasMaterialBuilder,
  required bool hasCupertinoBuilder,
}) {
  assert(
    hasBuilder || (hasMaterialBuilder && hasCupertinoBuilder),
    'Provide either `builder` (for both platforms) or both `materialBuilder` '
    'and `cupertinoBuilder`.',
  );
  assert(
    !hasBuilder || (!hasMaterialBuilder && !hasCupertinoBuilder),
    'If `builder` is provided, do not also provide `materialBuilder` or '
    '`cupertinoBuilder`.',
  );
}

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_choices.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPopupSurface;
import 'package:flutter/widgets.dart';

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';
import '/src/utils/design_language.dart';
import 'sheet_routes.dart';

/// Shows a modal that slides up from the bottom. [showModalBottomSheet] on Material, [showCupertinoModalPopup]
/// on Cupertino, wrapped there in a [CupertinoPopupSurface] because that route only positions and dims
/// where Material's paints a sheet. Skip the wrap with [showPlatformRawModalBottomSheet].
///
/// Same idea on both platforms, barely overlapping parameters. Material brings a pile of sheet-shape,
/// drag and safe-area knobs, Cupertino little more than a filter. Those live per-platform on
/// [materialModalBottomSheetData] / [cupertinoModalPopupData].
///
/// Either pass [builder] for content shared across both, or pass [materialBuilder] and [cupertinoBuilder]
/// together. Mixing the 2 trips an assert.
///
/// Guidelines: [M3 bottom sheets](https://m3.material.io/components/bottom-sheets/guidelines),
/// [HIG sheets](https://developer.apple.com/design/human-interface-guidelines/sheets#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_modal_bottom_sheet.dart#platform_modal_bottom_sheet}
Future<T?> showPlatformModalBottomSheet<T>({
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
      // Wrap in a CupertinoPopupSurface, the popup route only positions and dims. It paints no surface,
      // so unwrapped content has no sheet behind it.
      // (The route bottom-aligns the child, so no Center is needed here.)
      builder: (context) =>
          CupertinoPopupSurface(child: (cupertinoBuilder ?? builder!).call(context)),
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

/// Same as [showPlatformModalBottomSheet] minus the [CupertinoPopupSurface], so content there is
/// bare unless you bring your own. For an action sheet, use [showPlatformChoices].
///
/// The asymmetry is upstream's, not ours: Material's [showModalBottomSheet] always paints a sheet, which
/// you can flatten with a transparent `backgroundColor` on [materialModalBottomSheetData], while Cupertino's
/// route paints nothing. What you still get over calling the 2 directly is the dispatch and each platform's
/// own transition.
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

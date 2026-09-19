import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPopupSurface, showCupertinoModalPopup;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';

/// Shows a modal that slides up from the bottom. [showModalBottomSheet] on Android, [showCupertinoModalPopup]
/// on iOS, wrapped there in a [CupertinoPopupSurface] because that route only positions and dims where
/// Material's paints a sheet. Skip the wrap with [showPlatformRawModalBottomSheet].
///
/// Same idea on both platforms, barely overlapping parameters. Material brings a pile of sheet-shape,
/// drag and safe-area knobs, iOS brings a filter and a barrier. So almost everything lives per-platform
/// on [materialModalBottomSheetData] / [cupertinoModalPopupData].
///
/// Either pass [builder] for content shared across both, or pass [materialBuilder] and [cupertinoBuilder]
/// together. Mixing the 2 trips an assert.
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_modal_bottom_sheet.dart#platform_modal_bottom_sheet}
Future<T?> showPlatformModalBottomSheet<T>({
  required BuildContext context,
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  Offset? anchorPoint,
  bool? requestFocus,
  MaterialModalBottomSheetData? materialModalBottomSheetData,
  CupertinoModalPopupData? cupertinoModalPopupData,
}) {
  _assertBuilderInvariant(
    hasBuilder: builder != null,
    hasMaterialBuilder: materialBuilder != null,
    hasCupertinoBuilder: cupertinoBuilder != null,
  );

  return switch (defaultTargetPlatform) {
    .android => _showMaterialModalBottomSheet(
      context: context,
      builder: materialBuilder ?? builder!,
      data: materialModalBottomSheetData,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      anchorPoint: anchorPoint,
      requestFocus: requestFocus,
    ),
    .iOS => _showCupertinoModalPopup(
      context: context,
      // Wrap in a CupertinoPopupSurface, the popup route only positions and dims. It paints no surface,
      // so unwrapped content has no sheet behind it.
      // (The route bottom-aligns the child, so no Center is needed here.)
      builder: (context) =>
          CupertinoPopupSurface(child: (cupertinoBuilder ?? builder!).call(context)),
      data: cupertinoModalPopupData,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      anchorPoint: anchorPoint,
      requestFocus: requestFocus,
    ),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}

/// Same as [showPlatformModalBottomSheet] minus the iOS [CupertinoPopupSurface], so content there is
/// bare unless you bring your own. Handy for a `CupertinoActionSheet`, which already has one and would
/// otherwise end up double-chromed.
///
/// The asymmetry is upstream's, not ours: Android's [showModalBottomSheet] always paints a sheet, which
/// you can flatten with a transparent `backgroundColor` on [materialModalBottomSheetData], while iOS's
/// route paints nothing. What you still get over calling the 2 directly is the dispatch and each platform's
/// own transition.
Future<T?> showPlatformRawModalBottomSheet<T>({
  required BuildContext context,
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  Offset? anchorPoint,
  bool? requestFocus,
  MaterialModalBottomSheetData? materialModalBottomSheetData,
  CupertinoModalPopupData? cupertinoModalPopupData,
}) {
  _assertBuilderInvariant(
    hasBuilder: builder != null,
    hasMaterialBuilder: materialBuilder != null,
    hasCupertinoBuilder: cupertinoBuilder != null,
  );

  return switch (defaultTargetPlatform) {
    .android => _showMaterialModalBottomSheet(
      context: context,
      builder: materialBuilder ?? builder!,
      data: materialModalBottomSheetData,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      anchorPoint: anchorPoint,
      requestFocus: requestFocus,
    ),
    .iOS => _showCupertinoModalPopup(
      context: context,
      // Raw: no CupertinoPopupSurface wrap, the caller owns the surface.
      builder: cupertinoBuilder ?? builder!,
      data: cupertinoModalPopupData,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      anchorPoint: anchorPoint,
      requestFocus: requestFocus,
    ),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
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

/// Marshals [showModalBottomSheet]'s args out of [data]. One builder, not 2, so the AOT compiler can
/// fold the unused arm. See `test/aot_pruning_regression_test.dart`.
Future<T?> _showMaterialModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required MaterialModalBottomSheetData? data,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required Offset? anchorPoint,
  required bool? requestFocus,
}) => showModalBottomSheet(
  context: context,
  builder: builder,
  backgroundColor: data?.backgroundColor,
  barrierLabel: data?.barrierLabel,
  elevation: data?.elevation,
  shape: data?.shape,
  clipBehavior: data?.clipBehavior,
  constraints: data?.constraints,
  // No barrierColor: tinting a sheet's barrier is rare and the theme-derived default nearly always
  // right. Surface it if a real case turns up.
  isScrollControlled:
      data?.isScrollControlled ?? kDefaultMaterialModalBottomSheetIsScrollControlled,
  scrollControlDisabledMaxHeightRatio:
      data?.scrollControlDisabledMaxHeightRatio ??
      kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio,
  useRootNavigator: useRootNavigator,
  isDismissible: data?.isDismissible ?? kDefaultMaterialModalBottomSheetIsDismissible,
  enableDrag: data?.enableDrag ?? kDefaultMaterialModalBottomSheetEnableDrag,
  showDragHandle: data?.showDragHandle,
  useSafeArea: data?.useSafeArea ?? kDefaultMaterialModalBottomSheetUseSafeArea,
  routeSettings: routeSettings,
  transitionAnimationController: data?.transitionAnimationController,
  anchorPoint: anchorPoint,
  sheetAnimationStyle: data?.sheetAnimationStyle,
  requestFocus: requestFocus,
);

/// The iOS half of [_showMaterialModalBottomSheet]. Takes an already-wrapped [builder], surfaced or
/// bare depending on which entry point called it.
Future<T?> _showCupertinoModalPopup<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required CupertinoModalPopupData? data,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required Offset? anchorPoint,
  required bool? requestFocus,
}) => showCupertinoModalPopup(
  context: context,
  builder: builder,
  filter: data?.filter,
  barrierColor: data?.barrierColor ?? kDefaultCupertinoModalPopupBarrierColor,
  barrierDismissible: data?.barrierDismissible ?? kDefaultCupertinoModalPopupBarrierDismissible,
  useRootNavigator: useRootNavigator,
  semanticsDismissible:
      data?.semanticsDismissible ?? kDefaultCupertinoModalPopupSemanticsDismissible,
  routeSettings: routeSettings,
  anchorPoint: anchorPoint,
  requestFocus: requestFocus,
);

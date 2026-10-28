import 'package:cupertino_ui/cupertino_ui.dart'
    show kCupertinoModalBarrierColor, showCupertinoModalPopup;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet;

import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';

/// Feeds [showModalBottomSheet] from [materialModalBottomSheetData] and the flat settings. One builder,
/// not 2, so the AOT compiler can drop the unused arm. See `test/aot_pruning_regression_test.dart`.
@internal
Future<T?> showMaterialSheetRoute<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required MaterialModalBottomSheetData? materialModalBottomSheetData,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required bool barrierDismissible,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
}) => showModalBottomSheet(
  context: context,
  builder: builder,
  backgroundColor: materialModalBottomSheetData?.backgroundColor,
  barrierLabel: materialModalBottomSheetData?.barrierLabel,
  elevation: materialModalBottomSheetData?.elevation,
  shape: materialModalBottomSheetData?.shape,
  clipBehavior: materialModalBottomSheetData?.clipBehavior,
  constraints: materialModalBottomSheetData?.constraints,
  barrierColor: barrierColor,
  isScrollControlled:
      materialModalBottomSheetData?.isScrollControlled ??
      kDefaultMaterialModalBottomSheetIsScrollControlled,
  scrollControlDisabledMaxHeightRatio:
      materialModalBottomSheetData?.scrollControlDisabledMaxHeightRatio ??
      kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio,
  useRootNavigator: useRootNavigator,
  isDismissible: barrierDismissible,
  enableDrag:
      materialModalBottomSheetData?.enableDrag ?? kDefaultMaterialModalBottomSheetEnableDrag,
  showDragHandle: materialModalBottomSheetData?.showDragHandle,
  useSafeArea:
      materialModalBottomSheetData?.useSafeArea ?? kDefaultMaterialModalBottomSheetUseSafeArea,
  routeSettings: routeSettings,
  transitionAnimationController: materialModalBottomSheetData?.transitionAnimationController,
  anchorPoint: anchorPoint,
  sheetAnimationStyle: materialModalBottomSheetData?.sheetAnimationStyle,
  requestFocus: requestFocus,
);

/// The Cupertino half of [showMaterialSheetRoute]. Its [builder] comes wrapped in a surface or bare,
/// as the caller wants.
@internal
Future<T?> showCupertinoPopupRoute<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required CupertinoModalPopupData? cupertinoModalPopupData,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required bool barrierDismissible,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
}) => showCupertinoModalPopup(
  context: context,
  builder: builder,
  filter: cupertinoModalPopupData?.filter,
  barrierColor: barrierColor ?? kCupertinoModalBarrierColor,
  barrierDismissible: barrierDismissible,
  useRootNavigator: useRootNavigator,
  semanticsDismissible:
      cupertinoModalPopupData?.semanticsDismissible ??
      kDefaultCupertinoModalPopupSemanticsDismissible,
  routeSettings: routeSettings,
  anchorPoint: anchorPoint,
  requestFocus: requestFocus,
);

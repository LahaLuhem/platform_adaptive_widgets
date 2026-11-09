import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';

/// Feeds [showModalBottomSheet] from [materialModalBottomSheetData] and the flat settings. One builder,
/// not 2, so the AOT compiler can drop the unused arm. See `test/guards/aot_pruning.dart`.
@internal
Future<T?> showMaterialSheetRoute<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required MaterialModalBottomSheetData materialModalBottomSheetData,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required bool barrierDismissible,
  required RouteSettings? routeSettings,
  required bool? useRootNavigator,
  required bool? requestFocus,
}) => showModalBottomSheet(
  context: context,
  builder: builder,
  backgroundColor: materialModalBottomSheetData.backgroundColor,
  barrierLabel: materialModalBottomSheetData.barrierLabel,
  elevation: materialModalBottomSheetData.elevation,
  shape: materialModalBottomSheetData.shape,
  clipBehavior: materialModalBottomSheetData.clipBehavior,
  constraints: materialModalBottomSheetData.constraints,
  barrierColor: barrierColor,
  isScrollControlled: materialModalBottomSheetData.isScrollControlled,
  scrollControlDisabledMaxHeightRatio:
      materialModalBottomSheetData.scrollControlDisabledMaxHeightRatio,
  useRootNavigator: useRootNavigator ?? kMaterialSheetUseRootNavigator,
  isDismissible: barrierDismissible,
  enableDrag: materialModalBottomSheetData.enableDrag,
  showDragHandle: materialModalBottomSheetData.showDragHandle,
  useSafeArea: materialModalBottomSheetData.useSafeArea,
  routeSettings: routeSettings,
  transitionAnimationController: materialModalBottomSheetData.transitionAnimationController,
  anchorPoint: anchorPoint,
  sheetAnimationStyle: materialModalBottomSheetData.sheetAnimationStyle,
  requestFocus: requestFocus,
);

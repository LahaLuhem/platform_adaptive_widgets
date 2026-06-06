import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPopupSurface, showCupertinoModalPopup;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';

/// Shows a platform-adaptive modal popup that slides up from the bottom of
/// the screen. Material [showModalBottomSheet] on Android,
/// [showCupertinoModalPopup] on iOS — with the iOS content wrapped in a
/// [CupertinoPopupSurface], since that route only positions and dims (it paints
/// no sheet surface of its own, unlike Material's bottom sheet).
///
/// These two upstream APIs are conceptually similar (a modal that takes over
/// the bottom portion of the screen) but expose largely disjoint param sets —
/// Material has a rich set of sheet-shape / drag / safe-area knobs, Cupertino
/// has fewer (filter, barrier, semantics). Common show-function args are flat
/// on this function; everything else lives per-platform on
/// [materialModalBottomSheetData] / [cupertinoModalPopupData].
///
/// Content selection follows the same rules as `showPlatformDialog`:
/// - Pass [builder] for shared content on both platforms.
/// - Or pass both [materialBuilder] and [cupertinoBuilder] for per-platform
///   content.
/// - Combining `builder` with a platform-specific builder fires an assert.
///
/// Example:
/// ```dart
/// await showPlatformModalBottomSheet(
///   context: context,
///   builder: (_) => Padding(
///     padding: const EdgeInsets.all(16),
///     child: ListView(children: [...]),
///   ),
/// );
/// ```
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
  assert(
    builder != null || (materialBuilder != null && cupertinoBuilder != null),
    'Provide either `builder` (for both platforms) or both `materialBuilder` '
    'and `cupertinoBuilder`.',
  );
  assert(
    builder == null || (materialBuilder == null && cupertinoBuilder == null),
    'If `builder` is provided, do not also provide `materialBuilder` or '
    '`cupertinoBuilder`.',
  );

  return switch (defaultTargetPlatform) {
    .android => showModalBottomSheet(
      context: context,
      builder: materialBuilder ?? builder!,
      backgroundColor: materialModalBottomSheetData?.backgroundColor,
      barrierLabel: materialModalBottomSheetData?.barrierLabel,
      elevation: materialModalBottomSheetData?.elevation,
      shape: materialModalBottomSheetData?.shape,
      clipBehavior: materialModalBottomSheetData?.clipBehavior,
      constraints: materialModalBottomSheetData?.constraints,
      // Material's barrierColor not surfaced — sheet-level barrier tinting is
      // rare and the upstream default (null → theme-derived) is right almost
      // always. Add a flat shared `barrierColor` here if a real use case
      // appears.
      isScrollControlled:
          materialModalBottomSheetData?.isScrollControlled ??
          kDefaultMaterialModalBottomSheetIsScrollControlled,
      scrollControlDisabledMaxHeightRatio:
          materialModalBottomSheetData?.scrollControlDisabledMaxHeightRatio ??
          kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio,
      useRootNavigator: useRootNavigator,
      isDismissible:
          materialModalBottomSheetData?.isDismissible ??
          kDefaultMaterialModalBottomSheetIsDismissible,
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
    ),
    .iOS => showCupertinoModalPopup(
      context: context,
      // Wrap in a CupertinoPopupSurface — the popup route only positions and
      // dims; it paints no surface, so unwrapped content has no sheet behind it.
      // (The route bottom-aligns the child, so no Center is needed here.)
      builder: (context) => CupertinoPopupSurface(child: (cupertinoBuilder ?? builder!)(context)),
      filter: cupertinoModalPopupData?.filter,
      barrierColor:
          cupertinoModalPopupData?.barrierColor ?? kDefaultCupertinoModalPopupBarrierColor,
      barrierDismissible:
          cupertinoModalPopupData?.barrierDismissible ??
          kDefaultCupertinoModalPopupBarrierDismissible,
      useRootNavigator: useRootNavigator,
      semanticsDismissible:
          cupertinoModalPopupData?.semanticsDismissible ??
          kDefaultCupertinoModalPopupSemanticsDismissible,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      requestFocus: requestFocus,
    ),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}

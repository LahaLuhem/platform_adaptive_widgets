import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPopupSurface, showCupertinoModalPopup;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';

/// Shows a platform-adaptive modal popup that slides up from the bottom of the screen.
/// Material [showModalBottomSheet] on Android, [showCupertinoModalPopup] on iOS.
/// The iOS content wrapped in a [CupertinoPopupSurface], since that route only positions and dims
/// (it paints no sheet surface of its own, unlike Material's bottom sheet).
///
/// These two upstream APIs are conceptually similar (a modal that takes over the bottom portion of the screen)
/// but expose largely disjoint param sets. Material has a rich set of sheet-shape / drag / safe-area knobs,
/// Cupertino has fewer (filter, barrier, semantics). Common show-function args are flat on this function;
/// everything else lives per-platform on [materialModalBottomSheetData] / [cupertinoModalPopupData].
///
/// Content selection follows the same rules as `showPlatformDialog`:
/// - Pass [builder] for shared content on both platforms.
/// - Or pass both [materialBuilder] and [cupertinoBuilder] for per-platform content.
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
      // Wrap in a CupertinoPopupSurface — the popup route only positions and dims; it paints no surface,
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

/// Shows a raw, unopinionated bottom modal: the content is passed **without any surface wrapping**
/// to [showModalBottomSheet] on Android and [showCupertinoModalPopup] on iOS.
/// Unlike [showPlatformModalBottomSheet], the package adds no [CupertinoPopupSurface] on iOS.
/// The content is bare there unless you bring your own surface (e.g. a `CupertinoActionSheet` for
/// quick actions, which carries its own — wrapping it would double-chrome it).
///
/// The two platforms differ here because their native primitives do: Android's [showModalBottomSheet]
/// always renders its own `Material` sheet surface (tune it via [materialModalBottomSheetData],
/// or flatten it with a transparent `backgroundColor`), while iOS's [showCupertinoModalPopup] only
/// positions and dims. The value over calling those upstream functions directly is the adaptive
/// dispatch and the platform-native transition.
///
/// Accepts the same parameters as [showPlatformModalBottomSheet]; only the iOS [CupertinoPopupSurface] wrap is dropped.
Future<T?> showRawModalBottomSheet<T>({
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
      // Raw: no CupertinoPopupSurface wrap — the caller owns the surface.
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

/// Asserts exactly one of the two valid builder-input shapes was used: `builder` alone, or both
/// `materialBuilder` and `cupertinoBuilder` together. Mirrors the dialog-side check; takes the args'
/// *nullness* (booleans) rather than the builders so it can't name `material*`/`cupertino*`
/// function-typed params and trip the AOT-pruning guard (`test/aot_pruning_regression_test.dart`).
/// Used by [showPlatformModalBottomSheet] and [showRawModalBottomSheet].
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

/// Shared Material-side plumbing — marshals [showModalBottomSheet]'s args from
/// [data] without imposing content wrapping. Single-builder (the dispatch lives
/// at the public entry point) so the AOT compiler can fold the unused arm; see
/// `test/aot_pruning_regression_test.dart`.
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
  // Material's barrierColor not surfaced — sheet-level barrier tinting is rare
  // and the upstream default (null → theme-derived) is right almost always. Add
  // a flat shared `barrierColor` here if a real use case appears.
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

/// Shared Cupertino-side plumbing — see [_showMaterialModalBottomSheet]. Callers
/// pass an already-shaped [builder]: wrapped in [CupertinoPopupSurface] by
/// [showPlatformModalBottomSheet], or bare by [showRawModalBottomSheet].
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

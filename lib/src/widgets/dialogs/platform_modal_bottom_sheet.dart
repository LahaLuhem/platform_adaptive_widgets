/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_choices.dart';
/// @docImport '/src/widgets/dialogs/platform_sheet.dart';
/// @docImport '/src/widgets/interaction/platform_close_button.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoDynamicColor, CupertinoLocalizations, kCupertinoModalBarrierColor;
import 'package:flutter/widgets.dart';
import 'package:smooth_sheets/smooth_sheets.dart' show Sheet, showModalSheet;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';
import '/src/utils/design_language.dart';
import 'internal/builder_invariant.dart';
import 'internal/sheet_routes.dart';

/// Shows a modal that slides up from the bottom, [showModalBottomSheet] on Material and smooth_sheets'
/// [showModalSheet] on Cupertino, with nothing added around your content. Content or a short task fits
/// [showPlatformSheet] instead, and an action sheet [showPlatformChoices].
///
/// Material's [showModalBottomSheet] still paints a sheet, which you can flatten with a transparent
/// `backgroundColor` on [materialModalBottomSheetData]. Cupertino's paints nothing.
///
/// On Cupertino it sits at your content's height and closes on a swipe down or a tap above, as an iOS sheet
/// does. A [PopScope] in the content can ask first, and a [PlatformCloseButton] adds a visible way out.
/// [anchorPoint] and [requestFocus] only reach Material, since smooth_sheets takes neither.
///
/// Known gaps: cupertino_ui's own sheet would do, once it dims and closes on a tap above
/// ([flutter/flutter#196168](https://github.com/flutter/flutter/issues/196168)), sizes to its content
/// ([flutter/flutter#169832](https://github.com/flutter/flutter/issues/169832)) and asks a [PopScope] before
/// a swipe ([flutter/flutter#171878](https://github.com/flutter/flutter/issues/171878)).
///
/// Either pass [builder] for content shared across both, or pass [materialBuilder] and [cupertinoBuilder]
/// together. Mixing the 2 trips an assert.
///
/// Guidelines: [M3 bottom sheets](https://m3.material.io/components/bottom-sheets/guidelines),
/// [HIG modality](https://developer.apple.com/design/human-interface-guidelines/modality#Best-practices).
Future<T?> showPlatformRawModalBottomSheet<T>({
  required BuildContext context,
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
  Offset? anchorPoint,
  Color? barrierColor,
  bool barrierDismissible = kDefaultModalBottomSheetBarrierDismissible,
  RouteSettings? routeSettings,
  bool? useRootNavigator,
  bool? requestFocus,
  MaterialModalBottomSheetData materialModalBottomSheetData = const MaterialModalBottomSheetData(),
  @Deprecated('Does nothing since Cupertino moved to a sheet. Goes in the next major.')
  // Deprecated, kept only so callers still compile.
  // ignore: avoid-unused-parameters
  CupertinoModalPopupData cupertinoModalPopupData = const CupertinoModalPopupData(),
}) {
  assertBuilderInvariant(
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
    .cupertino => showModalSheet<T>(
      context: context,
      // Sized to the content, and paints nothing around it.
      builder: (context) => Sheet(child: (cupertinoBuilder ?? builder!)(context)),
      useRootNavigator: useRootNavigator ?? kDefaultUseRootNavigator,
      barrierDismissible: barrierDismissible,
      // Always, as on iOS. A PopScope in the content can still ask first.
      swipeDismissible: true,
      // Without a label, a screen reader gets no dismiss on the barrier.
      barrierLabel: CupertinoLocalizations.of(context).modalBarrierDismissLabel,
      // smooth_sheets would paint a dynamic colour's light value in dark mode too.
      barrierColor: CupertinoDynamicColor.resolve(
        barrierColor ?? kCupertinoModalBarrierColor,
        context,
      ),
      routeSettings: routeSettings,
    ),
  };
}

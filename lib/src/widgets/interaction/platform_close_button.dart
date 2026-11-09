/// @docImport '/src/widgets/dialogs/platform_dialog.dart';
/// @docImport '/src/widgets/dialogs/platform_modal_bottom_sheet.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoButton, CupertinoColors, CupertinoDynamicColor, CupertinoIcons;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show CloseButton;

import '/src/models/platform_widget_base.dart';

/// UIKit's iOS 18 close button.
const _kCupertinoCloseButtonDiameter = 30.0;

/// As wide as UIKit's X. cupertino_icons has no bold, so it reads lighter.
const _kCupertinoCloseButtonXmarkSize = 17.7;

/// cupertino_ui's coming `closeButtonLabel`, English in every language until its translations land.
const _kCupertinoCloseButtonLabel = 'Close';

/// A round X that closes its route: M3's [CloseButton] on Material, UIKit's iOS 18 close button on Cupertino.
///
/// For content with no bar, like a [showPlatformRawModalBottomSheet] or [showPlatformRawDialog]. Put it
/// top-leading, where the HIG puts Close. It pops through [Navigator.maybePop], so a [PopScope] can ask first.
///
/// Known gap: cupertino_ui has no Close string yet, so this copies the one
/// [flutter/packages#13589](https://github.com/flutter/packages/pull/13589) adds.
///
/// Guidelines: [M3 bottom sheets](https://m3.material.io/components/bottom-sheets/guidelines),
/// [HIG sheets](https://developer.apple.com/design/human-interface-guidelines/sheets#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_close_button.dart#platform_close_button}
class const PlatformCloseButton({
  /// Its screen-reader name on Cupertino, for an app that translates it. Left out, it's Close. Material's
  /// [CloseButton] names itself.
  final String? label,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive close button.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) => CloseButton(key: widgetKey);

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) => CupertinoButton(
    key: widgetKey,
    // Unpadded, so taps land a little past the circle, as on UIKit.
    padding: .zero,
    onPressed: () => Navigator.maybePop(context),
    child: Semantics(
      label: label ?? _kCupertinoCloseButtonLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(CupertinoColors.tertiarySystemFill, context),
          shape: .circle,
        ),
        child: SizedBox.square(
          dimension: _kCupertinoCloseButtonDiameter,
          child: Icon(
            CupertinoIcons.xmark,
            size: _kCupertinoCloseButtonXmarkSize,
            color: CupertinoDynamicColor.resolve(CupertinoColors.secondaryLabel, context),
          ),
        ),
      ),
    ),
  );
}

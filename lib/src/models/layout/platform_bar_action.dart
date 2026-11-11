/// @docImport '/src/utils/design_language.dart';
/// @docImport '/src/widgets/layout/platform_app_bar.dart';
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// How long a [PlatformBarAction.debounced]'s work runs before the bar shows it busy. M3's line between
/// instant and short waits, and the package's own pick on iOS, where the HIG gives none.
@internal
const kBarActionBusyDelay = Duration(milliseconds: 200);

/// One action in a bar, like Share or Save, drawn as each platform's own bar button.
sealed class const PlatformBarAction._({
  /// Names the action: its text without an [icon], its tooltip and screen-reader label with one.
  required final String label,

  /// Drawn in place of the [label]. Both platforms prefer a symbol in a bar, except for an action like
  /// Edit that has no good one.
  final Widget? icon,

  /// The way to disable it, like a Done that waits for the last step.
  final bool isEnabled = true,
}) {
  /// Creates an action for a bar like [PlatformAppBar]. Slow work wants [PlatformBarAction.debounced].
  const factory({
    required String label,
    required VoidCallback onPressed,
    Widget? icon,
    bool isEnabled,
  }) = PlainBarAction;

  /// Creates an action whose work takes a moment, like a save. Taps are ignored until the work is done.
  /// If it lasts, the platform's spinner takes the action's place, and screen readers read it as disabled.
  ///
  /// For short work, not for opening a screen or a sheet, whose future lasts until it closes
  /// ([M3 loading indicator](https://m3.material.io/components/loading-indicator/guidelines)). If the
  /// work throws, the action works again and the error goes uncaught. Each debounced action in a bar
  /// needs its own [label].
  ///
  /// The swap is instant, unless a [transitionBuilder] like [AnimatedSwitcher.defaultTransitionBuilder]
  /// animates it in each look's own timing, and the device doesn't ask for less motion. Switch on
  /// [designLanguage] in it for a motion per look.
  ///
  /// Known gap: Material shows a circular progress indicator until material_ui has M3's loading indicator
  /// ([flutter/flutter#184941](https://github.com/flutter/flutter/issues/184941)).
  const factory debounced({
    required String label,
    required AsyncCallback onPressed,
    Widget? icon,
    bool isEnabled,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) = DebouncedBarAction;

  /// What a tap runs.
  VoidCallback get onPressed;
}

/// What [PlatformBarAction.new] builds.
@internal
final class const PlainBarAction({
  required super.label,
  @override required final VoidCallback onPressed,
  super.icon,
  super.isEnabled,
}) extends PlatformBarAction {
  this : super._();
}

/// What [PlatformBarAction.debounced] builds.
@internal
final class const DebouncedBarAction({
  required super.label,
  @override required final AsyncCallback onPressed,
  super.icon,
  super.isEnabled,
  final AnimatedSwitcherTransitionBuilder? transitionBuilder,
}) extends PlatformBarAction {
  this : super._();
}

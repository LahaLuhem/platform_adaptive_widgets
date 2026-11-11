/// @docImport '/src/widgets/layout/platform_app_bar.dart';
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// How long a [PlatformBarAction.debounced]'s work runs before the bar shows it busy. M3's line between
/// instant and short waits, and the package's own pick on iOS, where the HIG gives none.
@internal
const kBarActionBusyDelay = Duration(milliseconds: 200);

/// One action in a bar, like Share or Save. The bar draws it as each platform's own bar button, so it
/// sits the way a native one does.
sealed class const PlatformBarAction._({
  /// Names the action. It's the text without an [icon], and the tooltip and screen-reader label with one.
  required final String label,

  /// Drawn in place of the [label]. Both platforms prefer a symbol in a bar, except for an action like
  /// Edit that has no good one.
  final Widget? icon,

  /// The way to disable it, like a Done that waits for the last step.
  final bool isEnabled = true,
}) {
  /// Creates an action for a bar like [PlatformAppBar].
  const factory({
    required String label,
    required VoidCallback onPressed,
    Widget? icon,
    bool isEnabled,
  }) = PlainBarAction;

  /// Creates an action whose work takes a moment, like Save. The bar ignores taps until that work is
  /// done.
  const factory debounced({
    required String label,
    required AsyncCallback onPressed,
    Widget? icon,
    bool isEnabled,
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
}) extends PlatformBarAction {
  this : super._();
}

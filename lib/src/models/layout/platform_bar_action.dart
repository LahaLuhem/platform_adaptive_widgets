/// @docImport '/src/widgets/layout/platform_app_bar.dart';
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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

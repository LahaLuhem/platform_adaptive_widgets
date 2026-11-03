import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Tells screen readers [child] is disabled, which cupertino_ui's
/// [button](https://github.com/flutter/flutter/issues/195514),
/// [segments](https://github.com/flutter/flutter/issues/195515) and
/// [slider](https://github.com/flutter/flutter/issues/106691) leave out, and drops the tap a disabled button
/// still offers.
///
/// Keep it in the tree while enabled too, so disabling doesn't rebuild [child] and lose its state.
@internal
final class const DisabledSemantics({
  required final bool isEnabled,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  /// Wraps [child] in its disabled state for screen readers.
  this;

  @override
  Widget build(BuildContext context) => Semantics(
    // Null while enabled, so an enabled widget reads exactly as cupertino_ui builds it.
    enabled: isEnabled ? null : false,
    child: IgnorePointer(ignoring: !isEnabled, child: child),
  );
}

/// @docImport '/src/widgets/dialogs/platform_choices.dart';
library;

import '/src/models/dialogs/platform_action_kind.dart';

/// One of the choices [showPlatformChoices] offers.
final class const PlatformChoice<T extends Object>({
  required final T value,

  /// Names what picking it does, like Delete Draft.
  required final String label,

  required final PlatformActionKind actionKind,
}) {
  /// Creates a choice.
  this;
}

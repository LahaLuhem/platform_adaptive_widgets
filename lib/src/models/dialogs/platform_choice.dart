/// @docImport '/src/widgets/dialogs/platform_choices.dart';
library;

import '/src/models/dialogs/platform_action_kind.dart';

/// One of the choices [showPlatformChoices] offers.
final class const PlatformChoice<T extends Object>({
  /// What [showPlatformChoices] returns when this one's picked.
  required final T value,

  /// Names what picking it does, like Delete Draft.
  required final String label,

  /// Picks the look, so a delete or discard stands out. See [PlatformActionKind].
  required final PlatformActionKind actionKind,
}) {
  /// Creates a choice.
  this;
}

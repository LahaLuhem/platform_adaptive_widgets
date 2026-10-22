/// @docImport '/src/widgets/dialogs/platform_confirm.dart';
library;

/// What an action does. The entry point it goes to sets the action's look from it, like
/// [showPlatformConfirm] does. Only Cupertino turns it into a look today, since Material's guidelines
/// keep every kind plain.
enum PlatformActionKind() {
  /// Harmless, like Send.
  normal,

  /// Destroys what the person asked to, like Delete after tapping Delete.
  delete,

  /// Loses what the person didn't ask to, like Discard after tapping Close.
  discard,
}

/// @docImport '/src/widgets/dialogs/platform_confirm.dart';
library;

/// What confirming does in [showPlatformConfirm], which sets its button's look on Cupertino. Material
/// keeps all 3 plain.
enum PlatformConfirmKind() {
  /// Harmless and likely, like Send. The primary button.
  proceed,

  /// Destroys what the person asked to, like Delete after tapping Delete. Plain.
  delete,

  /// Loses what the person didn't ask to, like Discard after tapping Close. Red.
  discard,
}

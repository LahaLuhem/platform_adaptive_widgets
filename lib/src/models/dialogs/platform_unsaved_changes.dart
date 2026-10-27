/// @docImport '/src/widgets/dialogs/platform_sheet.dart';
library;

/// Work the person hasn't saved in a [showPlatformSheet], so closing the sheet can ask first.
///
/// The ask's text has no default, since neither SDK's localizations carry one to fall back on.
final class const PlatformUnsavedChanges({
  /// Whether closing now would lose anything. It's asked at each try, so it sees changes made after
  /// the sheet opened.
  required final bool Function() hasChanges,

  /// The ask's question, like "Discard this list?".
  required final String message,

  /// The ask's button that drops the changes and closes the sheet, like "Discard".
  required final String discardLabel,
}) {
  /// Creates the unsaved changes a sheet asks about.
  this;
}

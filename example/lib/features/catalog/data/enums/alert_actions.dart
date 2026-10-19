/// What the Alert dialog card's alert offers, from a lone OK up to a destructive choice.
enum AlertActions {
  /// OK only, through `showPlatformAcknowledge`.
  acknowledge,

  /// OK and Cancel.
  confirm,

  /// OK, Delete and Cancel.
  destructive,
}

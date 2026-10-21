/// What the Alert dialog card's alert asks for.
enum AlertActions {
  /// OK only, through `showPlatformAcknowledge`.
  acknowledge,

  /// Cancel and a named action, through `showPlatformConfirm`.
  confirm,
}

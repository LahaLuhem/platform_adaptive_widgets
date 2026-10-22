/// What an action does, so the package can pick its look. Material's guidelines keep every kind plain.
enum PlatformActionKind() {
  /// Harmless, like Send.
  normal,

  /// Destroys what the person asked to, like Delete after tapping Delete.
  delete,

  /// Loses what the person didn't ask to, like Discard after tapping Close.
  discard,
}

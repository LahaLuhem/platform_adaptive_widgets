/// What an action does, so the package can pick its look. A delete or discard turns red where the HIG
/// asks on Cupertino, and takes M3's error colours on Material. See `APPENDIX.md#destructive-look`.
enum PlatformActionKind() {
  /// Harmless, like Send.
  normal,

  /// Destroys what the person asked to, like Delete after tapping Delete.
  delete,

  /// Loses what the person didn't ask to, like Discard after tapping Close.
  discard,
}

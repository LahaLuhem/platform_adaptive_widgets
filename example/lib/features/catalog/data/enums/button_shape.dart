/// Which `PlatformButton` constructor the Buttons playground builds.
enum ButtonShape {
  /// `PlatformButton.new`, around a text child.
  child,

  /// `PlatformButton.icon`, an icon before a label.
  icon,

  /// `PlatformButton.iconOnly`, its label read out by screen readers.
  iconOnly,
}

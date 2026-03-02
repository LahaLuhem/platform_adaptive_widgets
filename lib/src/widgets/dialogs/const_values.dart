import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;

/// Common constants used by platform-adaptive widgets.
abstract final class ConstValues {
  /// Default disabled color for a cupertino button of plain style.
  static const kCupertinoButtonDefaultDisabledColorPlain = CupertinoColors.quaternarySystemFill;

  /// Default disabled color for a cupertino button of coloured(tinted|filled) style.
  static const kCupertinoButtonDefaultDisabledColorColoured = CupertinoColors.tertiarySystemFill;

  /// The minimum number of items suggested for a Cupertino pull-down button by
  /// [HIG best-practices](https://developer.apple.com/design/human-interface-guidelines/pull-down-buttons#Best-practices)
  static const minNumCupertinoPullDownButtonItems = 3;

  /// The threshold for the number of items in a menu picker that determines whether to use a pull-down button or a modal picker.
  /// See [HIG best-practices](https://developer.apple.com/design/human-interface-guidelines/pickers#Best-practices)
  static const smallItemCountThreshold = 5;
}

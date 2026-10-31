import 'package:flutter/foundation.dart';

/// The widget family a `PlatformXxx` widget draws with.
enum DesignLanguage() {
  /// `material_ui` widgets.
  material,

  /// `cupertino_ui` widgets.
  cupertino,
}

/// Switch on it to match the widgets, one look per case, and release builds drop the losing arm with
/// everything only it builds. A `_` arm, `||`, `when` or `==` keeps all that in.
@pragma('vm:platform-const-if', !kDebugMode)
DesignLanguage get designLanguage =>
    // The pragma turns this into a constant early, like `defaultTargetPlatform`'s does, so release builds
    // only compile the look they show. That step can't read a switch expression, hence the conditional.
    defaultTargetPlatform == .iOS || defaultTargetPlatform == .macOS ? .cupertino : .material;

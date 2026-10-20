import 'package:flutter/foundation.dart';

/// The widget family a `PlatformXxx` widget draws with.
enum DesignLanguage() {
  /// `material_ui` widgets.
  material,

  /// `cupertino_ui` widgets.
  cupertino,
}

/// Switch on it to match the widgets. Release builds drop the losing arm.
DesignLanguage get designLanguage => switch (defaultTargetPlatform) {
  .iOS || .macOS => .cupertino,
  _ => .material,
};

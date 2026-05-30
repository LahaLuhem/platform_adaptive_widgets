import 'package:flutter/foundation.dart';

/// Whether the app is running on Android.
///
/// Const-folds at AOT in release builds via [defaultTargetPlatform]'s
/// `vm:platform-const-if` pragma, so `if (isAndroid) { … }` prunes the
/// dead branch.
bool get isAndroid => defaultTargetPlatform == .android;

/// Whether the app is running on iOS.
///
/// Const-folds at AOT in release builds via [defaultTargetPlatform]'s
/// `vm:platform-const-if` pragma, so `if (isIOS) { … }` prunes the
/// dead branch.
bool get isIOS => defaultTargetPlatform == .iOS;

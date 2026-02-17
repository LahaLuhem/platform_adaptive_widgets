import 'package:flutter/foundation.dart';

/// The reusable target platform for the app.
@protected
final targetPlatform = defaultTargetPlatform;

/// Whether the app is running on Android.
bool get isAndroid => targetPlatform == .android;

/// Whether the app is running on iOS.
bool get isIOS => targetPlatform == .iOS;

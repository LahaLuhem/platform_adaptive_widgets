import 'package:flutter/foundation.dart';

/// Runs [body] as if the app ran on [platform], for a unit test, which can't take a variant.
void onPlatform(TargetPlatform platform, VoidCallback body) {
  debugDefaultTargetPlatformOverride = platform;
  try {
    body();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

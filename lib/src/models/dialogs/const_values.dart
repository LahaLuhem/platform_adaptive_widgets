import 'package:flutter/foundation.dart';

/// Default value for whether dialogs, pickers and Cupertino popups use the root navigator.
@internal
const kDefaultUseRootNavigator = true;

/// Whether a Material modal bottom sheet uses the root navigator, `showModalBottomSheet`'s own default.
@internal
const kMaterialSheetUseRootNavigator = false;

/// Default barrier dismissibility for Material dialogs.
@internal
const kMaterialBarrierDismissible = true;

/// Default barrier dismissibility for Cupertino dialogs.
@internal
const kCupertinoBarrierDismissible = false;

/// Default barrier dismissibility for modal bottom sheets, the same on both platforms.
@internal
const kDefaultModalBottomSheetBarrierDismissible = true;

/// Default barrier dismissibility for the date and time pickers, the same on both platforms.
@internal
const kDefaultPickerBarrierDismissible = true;

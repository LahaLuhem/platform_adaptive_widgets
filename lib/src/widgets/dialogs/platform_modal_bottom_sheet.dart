import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart' show showModalBottomSheet;
import 'package:flutter/widgets.dart';

import '/src/extensions/context_extensions.dart';

/// Shows a platform-adaptive modal bottom sheet that renders Material showModalBottomSheet on Android
/// and showCupertinoModalPopup on iOS.
///
/// This function automatically selects the appropriate modal bottom sheet implementation based on the target platform:
/// - On Android: shows a Material Design modal bottom sheet
/// - On iOS: shows a Cupertino modal popup
///
/// The modal bottom sheet can be configured with platform-specific data through [builder].
///
/// Example:
/// ```dart
/// showPlatformModalBottomSheet(
///   context: context,
///   builder: (context) => Container(
///     padding: EdgeInsets.all(16),
///     child: Text('Bottom Sheet Content'),
///   ),
/// )
/// ```
Future<T?> showPlatformModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) => context.platformLazyValue(
  material: () => showModalBottomSheet<T>(context: context, builder: builder),
  cupertino: () => showCupertinoModalPopup<T>(context: context, builder: builder),
);

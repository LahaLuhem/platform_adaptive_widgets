import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart' show showModalBottomSheet;
import 'package:flutter/widgets.dart';

import '/extensions/context_extensions.dart';

Future<T?> showPlatformModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) => context.platformLazyValue(
  material: () => showModalBottomSheet<T>(context: context, builder: builder),
  cupertino: () => showCupertinoModalPopup<T>(context: context, builder: builder),
);

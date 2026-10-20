import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// The menu picker card's list lengths, either side of Cupertino's cutoff.
enum MenuPickerLength {
  menu(itemCount: kCupertinoMenuPickerSmallItemCountThreshold),
  wheel(itemCount: kCupertinoMenuPickerSmallItemCountThreshold + 1);

  final int itemCount;

  const MenuPickerLength({required this.itemCount});
}

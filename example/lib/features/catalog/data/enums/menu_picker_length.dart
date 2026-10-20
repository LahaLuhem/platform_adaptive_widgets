import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// The menu picker card's list lengths, one per Cupertino look.
enum MenuPickerLength {
  menu(itemCount: kCupertinoMenuPickerSmallItemCountThreshold),
  wheel(itemCount: kCupertinoMenuPickerSmallItemCountThreshold + 1),
  page(itemCount: kCupertinoMenuPickerLargeItemCountThreshold + 1);

  final int itemCount;

  const MenuPickerLength({required this.itemCount});
}

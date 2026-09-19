import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformMenuPicker] knob, labelling each option with the value's `name`.
///
/// Needs 3 values or more, which iOS asserts. Below that reach for `SegmentKnob` or a `BoolKnob`.
class EnumKnob<T extends Enum> extends StatelessWidget {
  final String label;

  final T value;

  final List<T> values;

  final ValueChanged<T> onChanged;

  const EnumKnob({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) => PlatformMenuPicker<T>(
    items: values,
    currentValue: value,
    labelText: label,
    onSelected: onChanged,
    menuPickerItemTransformer: (choice) => MenuPickerItem(label: choice.name),
  );
}

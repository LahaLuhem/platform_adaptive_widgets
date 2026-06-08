import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A labelled enum control for a property editor, backed by a
/// [PlatformMenuPicker] so the knob renders platform-adaptively. Each option's
/// label is the value's `name`.
///
/// `PlatformMenuPicker`'s Cupertino small-item rendering asserts at least three
/// items, so use this knob only for enums with three or more values; reach for
/// a segmented control or a boolean toggle for smaller enums.
class EnumKnob<T extends Enum> extends StatelessWidget {
  /// The property name shown as the picker's label.
  final String label;

  /// The current value.
  final T value;

  /// All selectable values — typically `MyEnum.values`.
  final List<T> values;

  /// Fired when the user picks a different value.
  final ValueChanged<T> onChanged;

  /// Creates an enum knob.
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

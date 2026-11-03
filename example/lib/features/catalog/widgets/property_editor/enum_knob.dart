import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformMenuPicker] knob, labelling each option with the value's `name`.
class const EnumKnob<T extends Enum>({
  required final String label,
  required final T? value,
  required final Set<T> values,
  required final ValueChanged<T> onChanged,

  /// Adds a "left out" option, which clears the value so the widget falls back to its own default.
  final VoidCallback? onCleared,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformMenuPicker<({T? value})>(
    // Records, since the picker takes no null item for "left out".
    items: {if (onCleared != null) (value: null), for (final value in values) (value: value)},
    currentValue: (value: value),
    labelText: label,
    onSelected: (choice) {
      final picked = choice.value;
      picked == null ? onCleared!() : onChanged(picked);
    },
    menuPickerItemTransformer: (choice) => MenuPickerItem(label: choice.value?.name ?? 'left out'),
  );
}

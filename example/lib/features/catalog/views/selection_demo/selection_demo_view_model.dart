import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show AxisDirection;
import 'package:pmvvm/pmvvm.dart';

/// State for the Selection-controls demo. The segmented button, radio group and
/// menu picker all read and write [selectedDirectionListenable], so changing
/// one updates the others — a small showcase of shared `ValueNotifier` state.
final class SelectionDemoViewModel extends ViewModel {
  final _checkboxValueNotifier = ValueNotifier(true);
  final _isSwitchOnNotifier = ValueNotifier(false);
  final _sliderValueNotifier = ValueNotifier<double>(0);
  final _selectedDirectionNotifier = ValueNotifier(AxisDirection.left);

  ValueListenable<bool> get checkboxValueListenable => _checkboxValueNotifier;

  ValueListenable<bool> get isSwitchOnListenable => _isSwitchOnNotifier;

  ValueListenable<double> get sliderValueListenable => _sliderValueNotifier;

  ValueListenable<AxisDirection> get selectedDirectionListenable => _selectedDirectionNotifier;

  void onCheckboxToggled({required bool value}) => _checkboxValueNotifier.value = value;

  void onSwitchToggled({required bool value}) => _isSwitchOnNotifier.value = value;

  void onSliderChanged({required double value}) => _sliderValueNotifier.value = value;

  void onDirectionChanged(AxisDirection? direction) =>
      _selectedDirectionNotifier.value = direction!;

  @override
  void dispose() {
    _checkboxValueNotifier.dispose();
    _isSwitchOnNotifier.dispose();
    _sliderValueNotifier.dispose();
    _selectedDirectionNotifier.dispose();

    super.dispose();
  }
}

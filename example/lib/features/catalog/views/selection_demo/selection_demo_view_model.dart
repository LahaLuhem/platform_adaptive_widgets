import 'package:flutter/widgets.dart' show AxisDirection, Color;
import 'package:pmvvm/pmvvm.dart';

/// State for the Selection-controls demo. The checkbox / switch / slider each
/// back a small playground (live value + visual knobs); the segmented button,
/// radio group and menu picker all read and write [selectedDirection], so
/// changing one updates the others — a showcase of shared selection state. All
/// state is flat fields mutated via `notifyListeners()` (see `CODESTYLE.md`'s
/// reactivity note on playground view-models).
final class SelectionDemoViewModel extends ViewModel {
  var _checkboxValue = true;
  var _shouldEnableCheckbox = true;
  var _checkboxActiveColor = const Color(0xFF2196F3);

  var _isSwitchOn = false;
  var _shouldEnableSwitch = true;
  var _switchActiveTrackColor = const Color(0xFF4CAF50);

  double _sliderValue = 0;
  var _shouldEnableSlider = true;
  var _sliderActiveColor = const Color(0xFF2196F3);
  var _sliderInactiveColor = const Color(0xFFFFFFFF);

  var _selectedDirection = AxisDirection.left;

  bool get checkboxValue => _checkboxValue;

  bool get shouldEnableCheckbox => _shouldEnableCheckbox;

  Color get checkboxActiveColor => _checkboxActiveColor;

  bool get isSwitchOn => _isSwitchOn;

  bool get shouldEnableSwitch => _shouldEnableSwitch;

  Color get switchActiveTrackColor => _switchActiveTrackColor;

  double get sliderValue => _sliderValue;

  bool get shouldEnableSlider => _shouldEnableSlider;

  Color get sliderActiveColor => _sliderActiveColor;

  Color get sliderInactiveColor => _sliderInactiveColor;

  AxisDirection get selectedDirection => _selectedDirection;

  void onCheckboxToggled({required bool value}) {
    _checkboxValue = value;
    notifyListeners();
  }

  void onCheckboxEnabledToggled({required bool value}) {
    _shouldEnableCheckbox = value;
    notifyListeners();
  }

  void onCheckboxActiveColorSelected(Color color) {
    _checkboxActiveColor = color;
    notifyListeners();
  }

  void onSwitchToggled({required bool value}) {
    _isSwitchOn = value;
    notifyListeners();
  }

  void onSwitchEnabledToggled({required bool value}) {
    _shouldEnableSwitch = value;
    notifyListeners();
  }

  void onSwitchActiveTrackColorSelected(Color color) {
    _switchActiveTrackColor = color;
    notifyListeners();
  }

  void onSliderChanged(double value) {
    _sliderValue = value;
    notifyListeners();
  }

  void onSliderEnabledToggled({required bool value}) {
    _shouldEnableSlider = value;
    notifyListeners();
  }

  void onSliderActiveColorSelected(Color color) {
    _sliderActiveColor = color;
    notifyListeners();
  }

  void onSliderInactiveColorSelected(Color color) {
    _sliderInactiveColor = color;
    notifyListeners();
  }

  void onDirectionChanged(AxisDirection? direction) {
    _selectedDirection = direction!;
    notifyListeners();
  }
}

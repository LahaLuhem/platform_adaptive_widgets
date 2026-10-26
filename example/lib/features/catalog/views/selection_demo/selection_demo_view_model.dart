import 'package:flutter/widgets.dart' show AxisDirection, Color;
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/menu_picker_length.dart';

/// State for the Selection controls demo. Its segmented button, radio group and first menu picker
/// share [selectedDirection], so moving one moves the others.
final class SelectionDemoViewModel extends ViewModel {
  var _checkboxValue = true;
  var _shouldEnableCheckbox = true;
  Color? _checkboxActiveColor;
  Color? _checkboxCheckColor;

  var _isSwitchOn = false;
  var _shouldEnableSwitch = true;
  Color? _switchActiveTrackColor;
  Color? _switchActiveThumbColor;
  Color? _switchInactiveThumbColor;

  double _sliderValue = 0;
  var _shouldEnableSlider = true;
  Color? _sliderActiveColor;
  Color? _sliderInactiveColor;
  Color? _sliderThumbColor;

  var _selectedDirection = AxisDirection.left;

  var _menuPickerLength = MenuPickerLength.menu;
  int? _pickedItem = 1;

  bool get checkboxValue => _checkboxValue;

  bool get shouldEnableCheckbox => _shouldEnableCheckbox;

  Color? get checkboxActiveColor => _checkboxActiveColor;

  Color? get checkboxCheckColor => _checkboxCheckColor;

  bool get isSwitchOn => _isSwitchOn;

  bool get shouldEnableSwitch => _shouldEnableSwitch;

  Color? get switchActiveTrackColor => _switchActiveTrackColor;

  Color? get switchActiveThumbColor => _switchActiveThumbColor;

  Color? get switchInactiveThumbColor => _switchInactiveThumbColor;

  double get sliderValue => _sliderValue;

  bool get shouldEnableSlider => _shouldEnableSlider;

  Color? get sliderActiveColor => _sliderActiveColor;

  Color? get sliderInactiveColor => _sliderInactiveColor;

  Color? get sliderThumbColor => _sliderThumbColor;

  AxisDirection get selectedDirection => _selectedDirection;

  MenuPickerLength get menuPickerLength => _menuPickerLength;

  int? get pickedItem => _pickedItem;

  void onCheckboxToggled({required bool value}) {
    _checkboxValue = value;
    notifyListeners();
  }

  void onCheckboxEnabledToggled({required bool value}) {
    _shouldEnableCheckbox = value;
    notifyListeners();
  }

  void onCheckboxActiveColorSelected(Color? color) {
    _checkboxActiveColor = color;
    notifyListeners();
  }

  void onCheckboxCheckColorSelected(Color? color) {
    _checkboxCheckColor = color;
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

  void onSwitchActiveTrackColorSelected(Color? color) {
    _switchActiveTrackColor = color;
    notifyListeners();
  }

  void onSwitchActiveThumbColorSelected(Color? color) {
    _switchActiveThumbColor = color;
    notifyListeners();
  }

  void onSwitchInactiveThumbColorSelected(Color? color) {
    _switchInactiveThumbColor = color;
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

  void onSliderActiveColorSelected(Color? color) {
    _sliderActiveColor = color;
    notifyListeners();
  }

  void onSliderInactiveColorSelected(Color? color) {
    _sliderInactiveColor = color;
    notifyListeners();
  }

  void onSliderThumbColorSelected(Color? color) {
    _sliderThumbColor = color;
    notifyListeners();
  }

  void onDirectionChanged(AxisDirection? direction) {
    _selectedDirection = direction!;
    notifyListeners();
  }

  // Keeps the pick, so a shorter list can show its value-outside-the-list state.
  void onMenuPickerLengthChanged(MenuPickerLength length) {
    _menuPickerLength = length;
    notifyListeners();
  }

  void onPickerItemSelected(int item) {
    _pickedItem = item;
    notifyListeners();
  }
}

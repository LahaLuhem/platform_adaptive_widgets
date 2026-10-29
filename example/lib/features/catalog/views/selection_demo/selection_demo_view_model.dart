import 'package:flutter/widgets.dart' show AxisDirection, Color;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart' show Weekday;
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/menu_picker_length.dart';

/// State for the Selection controls demo. Its segmented button, single-select list and first menu
/// picker share [selectedDirection], so moving one moves the others.
final class SelectionDemoViewModel extends ViewModel {
  var _repeatDays = {Weekday.saturday, Weekday.sunday};
  String? _repeatHeader = 'Repeat';

  var _isSwitchOn = false;
  Color? _switchActiveTrackColor;
  Color? _switchActiveThumbColor;
  Color? _switchInactiveThumbColor;

  double _sliderValue = 0;
  Color? _sliderActiveColor;
  Color? _sliderInactiveColor;
  Color? _sliderThumbColor;

  var _selectedDirection = AxisDirection.left;

  var _menuPickerLength = MenuPickerLength.menu;
  int? _pickedItem = 1;

  Set<Weekday> get repeatDays => _repeatDays;

  String? get repeatHeader => _repeatHeader;

  bool get isSwitchOn => _isSwitchOn;

  Color? get switchActiveTrackColor => _switchActiveTrackColor;

  Color? get switchActiveThumbColor => _switchActiveThumbColor;

  Color? get switchInactiveThumbColor => _switchInactiveThumbColor;

  double get sliderValue => _sliderValue;

  Color? get sliderActiveColor => _sliderActiveColor;

  Color? get sliderInactiveColor => _sliderInactiveColor;

  Color? get sliderThumbColor => _sliderThumbColor;

  AxisDirection get selectedDirection => _selectedDirection;

  MenuPickerLength get menuPickerLength => _menuPickerLength;

  int? get pickedItem => _pickedItem;

  void onRepeatDaysChanged(Set<Weekday> days) {
    _repeatDays = days;
    notifyListeners();
  }

  // An empty header would still draw its padding, so the knob's empty field means none.
  void onRepeatHeaderChanged(String text) {
    _repeatHeader = text.isEmpty ? null : text;
    notifyListeners();
  }

  void onSwitchToggled({required bool value}) {
    _isSwitchOn = value;
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

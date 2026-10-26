import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButtonSize;
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/button_shape.dart';

/// The Buttons playground's editable state. The `cupertino…` fields feed `cupertinoButtonData`.
final class ButtonsDemoViewModel extends ViewModel {
  var _shouldEnable = true;
  var _shape = ButtonShape.child;
  var _emphasis = PlatformButtonEmphasis.high;
  var _actionKind = PlatformActionKind.normal;

  Color? _cupertinoColor;
  Color? _cupertinoForegroundColor;
  var _cupertinoPressedOpacity = 0.4;
  var _cupertinoSizeStyle = CupertinoButtonSize.large;

  bool get shouldEnable => _shouldEnable;

  ButtonShape get shape => _shape;

  PlatformButtonEmphasis get emphasis => _emphasis;

  PlatformActionKind get actionKind => _actionKind;

  Color? get cupertinoColor => _cupertinoColor;

  Color? get cupertinoForegroundColor => _cupertinoForegroundColor;

  double get cupertinoPressedOpacity => _cupertinoPressedOpacity;

  CupertinoButtonSize get cupertinoSizeStyle => _cupertinoSizeStyle;

  Future<void> onButtonPressed(String label) =>
      showPlatformToast(context: context, message: '$label button pressed');

  void onEnabledToggled({required bool value}) {
    _shouldEnable = value;
    notifyListeners();
  }

  void onShapeChanged(ButtonShape shape) {
    _shape = shape;
    notifyListeners();
  }

  void onEmphasisSelected(PlatformButtonEmphasis emphasis) {
    _emphasis = emphasis;
    notifyListeners();
  }

  void onActionKindChanged(PlatformActionKind actionKind) {
    _actionKind = actionKind;
    notifyListeners();
  }

  void onCupertinoColorSelected(Color? color) {
    _cupertinoColor = color;
    notifyListeners();
  }

  void onCupertinoForegroundColorSelected(Color? color) {
    _cupertinoForegroundColor = color;
    notifyListeners();
  }

  void onCupertinoPressedOpacityChanged(double value) {
    _cupertinoPressedOpacity = value;
    notifyListeners();
  }

  void onCupertinoSizeStyleSelected(CupertinoButtonSize size) {
    _cupertinoSizeStyle = size;
    notifyListeners();
  }
}

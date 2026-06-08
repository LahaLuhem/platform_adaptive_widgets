import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButtonSize;
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// State for the Buttons demo — the `PlatformButton` playground's editable
/// properties, exposed as flat fields mutated by `on…` methods that call
/// `notifyListeners()` (see `CODESTYLE.md`'s reactivity note on playground
/// view-models). The `cupertino…` fields back the iOS-only panel (fed to
/// `cupertinoButtonData`). [onButtonPressed] toasts the press.
final class ButtonsDemoViewModel extends ViewModel {
  var _shouldEnable = true;
  var _shouldUseIcon = false;
  var _materialVariant = MaterialButtonVariant.elevated;
  var _cupertinoVariant = CupertinoButtonVariant.normal;

  var _cupertinoColor = const Color(0xFF2196F3);
  var _cupertinoForegroundColor = const Color(0xFFFFFFFF);
  var _cupertinoPressedOpacity = 0.4;
  var _cupertinoSizeStyle = CupertinoButtonSize.large;

  bool get shouldEnable => _shouldEnable;

  bool get shouldUseIcon => _shouldUseIcon;

  MaterialButtonVariant get materialVariant => _materialVariant;

  CupertinoButtonVariant get cupertinoVariant => _cupertinoVariant;

  Color get cupertinoColor => _cupertinoColor;

  Color get cupertinoForegroundColor => _cupertinoForegroundColor;

  double get cupertinoPressedOpacity => _cupertinoPressedOpacity;

  CupertinoButtonSize get cupertinoSizeStyle => _cupertinoSizeStyle;

  Future<void> onButtonPressed(String label) =>
      showPlatformToast(context: context, message: '$label button pressed');

  void onEnabledToggled({required bool value}) {
    _shouldEnable = value;
    notifyListeners();
  }

  void onUseIconToggled({required bool value}) {
    _shouldUseIcon = value;
    notifyListeners();
  }

  void onMaterialVariantSelected(MaterialButtonVariant variant) {
    _materialVariant = variant;
    notifyListeners();
  }

  void onCupertinoVariantSelected(CupertinoButtonVariant variant) {
    _cupertinoVariant = variant;
    notifyListeners();
  }

  void onCupertinoColorSelected(Color color) {
    _cupertinoColor = color;
    notifyListeners();
  }

  void onCupertinoForegroundColorSelected(Color color) {
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

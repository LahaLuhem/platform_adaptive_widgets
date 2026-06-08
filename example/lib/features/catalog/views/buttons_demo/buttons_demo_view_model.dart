import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// State for the Buttons demo — the `PlatformButton` playground's editable
/// shared-visual properties, exposed as flat fields mutated by `on…` methods
/// that call `notifyListeners()` (see `CODESTYLE.md`'s reactivity note on
/// playground view-models). [onButtonPressed] toasts the press.
final class ButtonsDemoViewModel extends ViewModel {
  var _shouldEnable = true;
  var _shouldUseIcon = false;
  var _materialVariant = MaterialButtonVariant.elevated;
  var _cupertinoVariant = CupertinoButtonVariant.normal;

  bool get shouldEnable => _shouldEnable;

  bool get shouldUseIcon => _shouldUseIcon;

  MaterialButtonVariant get materialVariant => _materialVariant;

  CupertinoButtonVariant get cupertinoVariant => _cupertinoVariant;

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
}

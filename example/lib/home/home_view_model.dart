import 'package:flutter/foundation.dart';
import 'package:pmvvm/pmvvm.dart';

final class HomeViewModel extends ViewModel {
  final _isSwitchEnabledNotifier = ValueNotifier(false);
  final _sliderValueNotifier = ValueNotifier<double>(0);

  ValueListenable<bool> get isSwitchEnabledListenable => _isSwitchEnabledNotifier;
  ValueListenable<double> get sliderValueListenable => _sliderValueNotifier;

  // Tear-off signature
  //ignore: avoid_positional_boolean_parameters
  void onSwitchChanged(bool value) {
    _isSwitchEnabledNotifier.value = value;
    debugPrint('Switch changed to $value');
  }

  void onSliderChanged(double value) {
    _sliderValueNotifier.value = value;
    debugPrint('Slider changed to $value');
  }

  void onAddPressed() => debugPrint('FAB pressed');

  @override
  void dispose() {
    _isSwitchEnabledNotifier.dispose();
    _sliderValueNotifier.dispose();

    super.dispose();
  }
}

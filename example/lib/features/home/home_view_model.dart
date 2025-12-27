import 'package:flutter/foundation.dart';
import 'package:pmvvm/pmvvm.dart';

final class HomeViewModel extends ViewModel {
  final _sliderValueNotifier = ValueNotifier<double>(0);
  final _isSwitchEnabledNotifier = ValueNotifier(false);

  ValueListenable<double> get sliderValueListenable => _sliderValueNotifier;
  ValueListenable<bool> get isSwitchEnabledListenable => _isSwitchEnabledNotifier;

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
    _sliderValueNotifier.dispose();
    _isSwitchEnabledNotifier.dispose();

    super.dispose();
  }
}

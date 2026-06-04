import 'package:flutter/foundation.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/showcase/data/navigation/platform_route.dart';
import 'pushed_demo_page.dart';

/// State for the "Under the hood" tab's interactive proofs: the tap counter
/// that survives tab switches (proving the tab is kept alive, not rebuilt), the
/// enable/disable gate, and the tri-state checkbox. Also routes the two page
/// pushes through [pushPlatformRoute].
final class ShowcaseViewModel extends ViewModel {
  final _tapCountNotifier = ValueNotifier(0);
  final _controlEnabledNotifier = ValueNotifier(true);
  final _gatedValueNotifier = ValueNotifier(true);
  final _checkboxValueNotifier = ValueNotifier<bool?>(false);

  /// Tap count for the persistence probe — survives tab switches as long as the
  /// tab's state is kept alive.
  ValueListenable<int> get tapCountListenable => _tapCountNotifier;

  /// Whether the gated control below the master switch is enabled.
  ValueListenable<bool> get controlEnabledListenable => _controlEnabledNotifier;

  ValueListenable<bool> get gatedValueListenable => _gatedValueNotifier;

  ValueListenable<bool?> get checkboxValueListenable => _checkboxValueNotifier;

  void onProbeIncremented() => _tapCountNotifier.value++;

  void onControlEnabledToggled({required bool value}) => _controlEnabledNotifier.value = value;

  void onGatedToggled({required bool value}) => _gatedValueNotifier.value = value;

  void onCheckboxToggled({required bool? value}) => _checkboxValueNotifier.value = value;

  Future<void> onPushPagePressed({required bool large}) =>
      pushPlatformRoute(context, (_) => PushedDemoPage(large: large));

  @override
  void dispose() {
    _tapCountNotifier.dispose();
    _controlEnabledNotifier.dispose();
    _gatedValueNotifier.dispose();
    _checkboxValueNotifier.dispose();

    super.dispose();
  }
}

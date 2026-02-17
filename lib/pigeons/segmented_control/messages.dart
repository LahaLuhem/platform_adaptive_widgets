// Internal usages only
// Definition file
// ignore_for_file: public_member_api_docs, prefer-match-file-name,

// Only used for generation
// ignore: depend_on_referenced_packages
import 'package:golubets/golubets.dart';

/// Configuration data sent from Dart to the native side.
@ConfigureGolubets(
  GolubetsOptions(
    dartOut: 'lib/pigeons/segmented_control/segmented_control.g.dart',
    swiftOut:
        'ios/platform_adaptive_widgets/Sources/platform_adaptive_widgets/segmented_control/segmented_control.g.swift',
    dartPackageName: 'platform_adaptive_widgets',
  ),
)
final class CupertinoSegmentedConfig {
  const CupertinoSegmentedConfig({
    required this.choices,
    this.selectedChoice,
    this.disabledChoices = const <String>[],
    this.thumbColor = 0xFFFFFFFF, // ARGB int
    this.backgroundColor = 0x00000000, // ARGB int
    this.padding = const <double>[3, 2, 3, 2], // [left, top, right, bottom]
    this.proportionalWidth = false,
    this.isMomentary = false,
  });

  final List<String> choices;
  final String? selectedChoice;
  final List<String> disabledChoices;
  final int thumbColor;
  final int backgroundColor;
  final List<double> padding; // [left, top, right, bottom]
  final bool proportionalWidth;
  final bool isMomentary;
}

// /// Callback interface for events from native to Dart.
// @FlutterApi()
// abstract class CupertinoSegmentedCallback {
//   void onSelectionChanged(String selectedChoice);
// }

/// Host API for creating and updating the native control.
@HostApi()
abstract class CupertinoSegmentedControlApi {
  /// Creates a new native view with the given [viewId] and initial [config].
  /// The [callback] will be used to send events back to Dart.
  void create(int viewId, CupertinoSegmentedConfig config);

  /// Updates an existing view identified by [viewId] with new [config].
  void update(int viewId, CupertinoSegmentedConfig config);
}

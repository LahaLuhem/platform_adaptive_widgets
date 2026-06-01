/// @docImport '/src/widgets/interaction/platform_radio.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ButtonSegment, SegmentedButton;

import '/src/models/interaction/platform_segment_button_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive segmented button that renders Material [SegmentedButton] on
/// Android and [CupertinoSlidingSegmentedControl] on iOS.
///
/// All functional inputs (choices, selection, callback) live as flat constructor
/// parameters. Per-platform visual + behavioural tuning is opt-in via
/// [materialSegmentButtonData] and [cupertinoSegmentButtonData]. See
/// `APPENDIX.md#field-classification`.
///
/// **Single-selection only.** Material's [SegmentedButton] supports multi-select via
/// `multiSelectionEnabled` + a `Set<T>` selection; Cupertino's
/// [CupertinoSlidingSegmentedControl] does not. Exposing multi-select on Material-only
/// would mean the same widget in the same view behaves differently across platforms
/// (Android multi, iOS single) — a cross-platform UX inconsistency that contradicts
/// the package's value proposition. Apps that need multi-select across both platforms
/// should reach for a different widget shape (chips, checkbox lists,
/// [PlatformRadioGroupBuilder] with toggle semantics, etc.). The package's
/// [onSelectionChanged] signature is `ValueChanged<T?>` accordingly; Material's
/// underlying `Set<T>` is collapsed to `set.firstOrNull` at the Material-branch
/// boundary.
///
/// No `isEnabled` flag — neither [SegmentedButton] nor
/// [CupertinoSlidingSegmentedControl] ships a built-in disabled state. To disable
/// interaction, wrap with [IgnorePointer] (or [Opacity] for a faded-out look).
///
/// Example:
/// ```dart
/// PlatformSegmentButton<String>(
///   choices: const ['Day', 'Week', 'Month'],
///   segmentBuilder: (choice) => Text(choice),
///   selectedChoice: _selectedView,
///   onSelectionChanged: (choice) => setState(() => _selectedView = choice),
/// )
/// ```
class PlatformSegmentButton<T extends Object> extends PlatformWidgetKeyedBase {
  /// Values to render as segments. One [segmentBuilder] call per choice, in iteration
  /// order. Must contain at least two entries (Cupertino asserts this at construction).
  final Iterable<T> choices;

  /// Builds the widget for one segment — typically a [Text] or [Icon].
  final Widget Function(T choice) segmentBuilder;

  /// Currently-selected choice. `null` means no selection.
  ///
  /// On Material, an empty selection requires
  /// [MaterialSegmentButtonData.emptySelectionAllowed] to be `true` — otherwise
  /// [SegmentedButton] asserts at runtime.
  final T? selectedChoice;

  /// Callback fired when the user taps a segment.
  ///
  /// Required and non-null per the callback-nullability rule
  /// (`APPENDIX.md#callback-nullability`) — [CupertinoSlidingSegmentedControl]
  /// requires its `onValueChanged` to be non-null at construction.
  ///
  /// The callback may receive `null` if a Material momentary-style tap clears the
  /// selection (only possible when [MaterialSegmentButtonData.emptySelectionAllowed]
  /// is `true`).
  final ValueChanged<T?> onSelectionChanged;

  /// Material-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record drive the Material branch only; Material-only fields
  /// (`style`, `selectedIcon`, `expandedInsets`, `emptySelectionAllowed`,
  /// `showSelectedIcon`, `direction`) are read only from here.
  final MaterialSegmentButtonData? materialSegmentButtonData;

  /// Cupertino-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record drive the Cupertino branch only; Cupertino-only fields
  /// (`disabledChildren`, `thumbColor`, `padding`, `backgroundColor`,
  /// `proportionalWidth`, `isMomentary`) are read only from here.
  final CupertinoSegmentButtonData<T>? cupertinoSegmentButtonData;

  /// Creates a platform-adaptive segmented button.
  const PlatformSegmentButton({
    required this.choices,
    required this.segmentBuilder,
    required this.selectedChoice,
    required this.onSelectionChanged,
    this.materialSegmentButtonData,
    this.cupertinoSegmentButtonData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => SegmentedButton<T>(
    key: widgetKey,
    segments: [
      for (final choice in choices) ButtonSegment(value: choice, label: segmentBuilder(choice)),
    ],
    selected: {?selectedChoice},
    onSelectionChanged: (set) => onSelectionChanged(set.firstOrNull),
    emptySelectionAllowed:
        materialSegmentButtonData?.emptySelectionAllowed ??
        kDefaultSegmentButtonEmptySelectionAllowed,
    expandedInsets: materialSegmentButtonData?.expandedInsets,
    style: materialSegmentButtonData?.style,
    showSelectedIcon:
        materialSegmentButtonData?.showSelectedIcon ?? kDefaultSegmentButtonShowSelectedIcon,
    selectedIcon: materialSegmentButtonData?.selectedIcon,
    direction: materialSegmentButtonData?.direction ?? kDefaultSegmentButtonDirection,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSlidingSegmentedControl<T>(
    key: widgetKey,
    children: {for (final choice in choices) choice: segmentBuilder(choice)},
    groupValue: selectedChoice,
    onValueChanged: onSelectionChanged,
    disabledChildren:
        cupertinoSegmentButtonData?.disabledChildren ??
        kDefaultCupertinoSegmentButtonDisabledChildren,
    thumbColor: cupertinoSegmentButtonData?.thumbColor ?? kDefaultCupertinoSegmentButtonThumbColor,
    padding: cupertinoSegmentButtonData?.padding ?? kDefaultCupertinoSegmentButtonPadding,
    backgroundColor:
        cupertinoSegmentButtonData?.backgroundColor ??
        kDefaultCupertinoSegmentButtonBackgroundColor,
    proportionalWidth:
        cupertinoSegmentButtonData?.proportionalWidth ??
        kDefaultCupertinoSegmentButtonProportionalWidth,
    isMomentary:
        cupertinoSegmentButtonData?.isMomentary ?? kDefaultCupertinoSegmentButtonIsMomentary,
  );
}

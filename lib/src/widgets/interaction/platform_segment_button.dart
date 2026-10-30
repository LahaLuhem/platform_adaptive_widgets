/// @docImport '/src/widgets/interaction/platform_multi_select_list.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ButtonSegment, SegmentedButton;

import '/src/models/interaction/platform_segment_button_data.dart';
import '/src/models/platform_widget_base.dart';
import '/src/widgets/interaction/disabled_semantics.dart';

const _kTooFewChoicesMessage =
    'Pass at least 2 choices. With 1 there is nothing to switch between.';

const _kSelectedMissingMessage = 'Pass one of the choices as selectedChoice, or null for none.';

/// [SegmentedButton] on Material, [CupertinoSlidingSegmentedControl] on Cupertino.
///
/// Per-platform tuning lives in [materialSegmentButtonData] / [cupertinoSegmentButtonData]. See `APPENDIX.md#field-classification`.
///
/// One selection at a time, deliberately. Material can do multi-select, Cupertino can't, and shipping
/// that would mean the same widget behaving differently on the 2 platforms, which is the opposite of
/// what this package is for. Hence [onSelectionChanged] taking a single `T?`, with Material's `Set<T>`
/// collapsed on the way through. For multi-select everywhere, use [PlatformMultiSelectList].
///
/// No `isEnabled` either, since neither underlying widget has a disabled state. Wrap it in an [IgnorePointer],
/// with an [Opacity] if you want it to look the part too.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_segment_button.dart#platform_segment_button}
class const PlatformSegmentButton<T extends Object>({
  /// Shown in the set's order. Needs at least 2.
  required final Set<T> choices,

  /// Usually a [Text] or an [Icon].
  required final Widget Function(T choice) segmentBuilder,

  /// One of [choices], or `null` for nothing selected, which on Material needs [MaterialSegmentButtonData.emptySelectionAllowed]
  /// or [SegmentedButton] trips an assert.
  required final T? selectedChoice,

  /// Stays required and non-null, since Cupertino won't construct without it. It can still hand you
  /// `null` when a Material tap clears the selection. See `APPENDIX.md#callback-nullability`.
  required final ValueChanged<T?> onSelectionChanged,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialSegmentButtonData? materialSegmentButtonData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoSegmentButtonData<T>? cupertinoSegmentButtonData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive segmented button.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) {
    _assertChoices();

    return SegmentedButton<T>(
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
  }

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) {
    _assertChoices();
    final disabledChildren =
        cupertinoSegmentButtonData?.disabledChildren ??
        kDefaultCupertinoSegmentButtonDisabledChildren;

    return CupertinoSlidingSegmentedControl<T>(
      key: widgetKey,
      children: {
        for (final choice in choices)
          choice: DisabledSemantics(
            isEnabled: !disabledChildren.contains(choice),
            child: segmentBuilder(choice),
          ),
      },
      groupValue: selectedChoice,
      onValueChanged: onSelectionChanged,
      disabledChildren: disabledChildren,
      thumbColor:
          cupertinoSegmentButtonData?.thumbColor ?? kDefaultCupertinoSegmentButtonThumbColor,
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

  // Both looks reject these alike. Cupertino would assert anyway, and Material would draw them silently.
  void _assertChoices() {
    assert(choices.length >= 2, _kTooFewChoicesMessage);
    assert(selectedChoice == null || choices.contains(selectedChoice), _kSelectedMissingMessage);
  }
}

import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/semantics.dart' show SemanticsData, SemanticsNode;
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart' show designLanguage;

/// The buttons a screen reader would read out as [name], as a label or a tooltip.
FinderBase<SemanticsNode> buttonsNamed(String name) => find.semantics.byPredicate((node) {
  final data = node.getSemanticsData();

  return data.flagsCollection.isButton && (data.label == name || data.tooltip == name);
});

/// Whether a screen reader hears [data] as picked: a checked control on Material, a selected row on iOS.
bool readsAsPicked(SemanticsData data) => switch (designLanguage) {
  .material => data.flagsCollection.isChecked == CheckedState.isTrue,
  .cupertino => data.flagsCollection.isSelected == Tristate.isTrue,
};

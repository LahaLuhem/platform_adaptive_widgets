import 'package:flutter/semantics.dart' show SemanticsNode;
import 'package:flutter_test/flutter_test.dart';

/// The buttons a screen reader would read out as [name], as a label or a tooltip.
FinderBase<SemanticsNode> buttonsNamed(String name) => find.semantics.byPredicate((node) {
  final data = node.getSemanticsData();

  return data.flagsCollection.isButton && (data.label == name || data.tooltip == name);
});

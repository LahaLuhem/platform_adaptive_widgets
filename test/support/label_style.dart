import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// How [label] is painted, inherited style included.
TextStyle labelStyle(WidgetTester tester, String label) => tester
    .widget<RichText>(find.descendant(of: find.text(label).last, matching: find.byType(RichText)))
    .text
    .style!;

int argbOf(TextStyle textStyle) => textStyle.color!.toARGB32();

int weightOf(TextStyle textStyle) => (textStyle.fontWeight ?? FontWeight.normal).value;

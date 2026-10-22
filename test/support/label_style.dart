import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The style the last [Text] reading [label] paints with, its [DefaultTextStyle] merged in.
TextStyle labelStyle(WidgetTester tester, String label) => tester
    .widget<RichText>(find.descendant(of: find.text(label).last, matching: find.byType(RichText)))
    .text
    .style!;

int argbOf(TextStyle style) => style.color!.toARGB32();

/// No weight paints as regular.
int weightOf(TextStyle style) => (style.fontWeight ?? FontWeight.normal).value;

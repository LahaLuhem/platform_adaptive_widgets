import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Material;

/// How far [message] sits from the top and the leading edge of the surface it's drawn on.
({double top, double side}) messageInsets(WidgetTester tester, String message) {
  final messageRect = tester.getRect(find.text(message));
  final surfaceRect = tester.getRect(
    find.ancestor(of: find.text(message), matching: find.byType(Material)).first,
  );

  return (top: messageRect.top - surfaceRect.top, side: messageRect.left - surfaceRect.left);
}

import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoAlertDialog, CupertinoSwitch;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show AlertDialog, Switch;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

final _everyPlatform = TargetPlatformVariant.all();

// Spelled out here rather than read off the package, so a wrong mapping can't pass.
bool get _isApple => defaultTargetPlatform == .iOS || defaultTargetPlatform == .macOS;

void main() {
  feature('Platform support', () {
    scenarioWidgets('Apple platforms get Cupertino widgets, the rest Material', (tester) async {
      // ignore: no-empty-block, only which switch shows up matters here.
      await pumpInPlatformScaffold(tester, PlatformSwitch(value: true, onChanged: (_) {}));

      check(tester.any(find.byType(_isApple ? CupertinoSwitch : Switch))).isTrue();
    }, variant: _everyPlatform);

    scenarioWidgets('dialogs open on every platform', (tester) async {
      final context = await pumpForContext(tester);

      unawaited(showPlatformAlertDialog<void>(context: context, content: const Text('Saved')));
      await tester.pumpAndSettle();

      check(tester.any(find.byType(_isApple ? CupertinoAlertDialog : AlertDialog))).isTrue();
    }, variant: _everyPlatform);

    scenarioWidgets('value pickers pick on every platform', (tester) async {
      check(platformValue(material: 'material', cupertino: 'cupertino'))
          .equals(_isApple ? 'cupertino' : 'material');
    }, variant: _everyPlatform);
  });
}

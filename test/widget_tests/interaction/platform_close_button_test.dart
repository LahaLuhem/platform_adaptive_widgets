import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show MaterialLocalizations;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

// Not English, so it can't pass by matching Material's own Close.
const _label = 'Schließen';

const _pageKey = Key('page');
const _page = Center(
  key: _pageKey,
  child: PlatformCloseButton(label: _label),
);

Future<String?> _open(BuildContext context, {Widget page = _page}) =>
    Navigator.of(context).push(PageRouteBuilder<String>(pageBuilder: (_, _, _) => page));

bool _isOpen() => find.byKey(_pageKey).evaluate().isNotEmpty;

void main() {
  feature('PlatformCloseButton', () {
    scenarioWidgets('closes the route it sits in, with no value', (tester) async {
      final result = _open(await pumpForContext(tester));
      await pumpTransition(tester);
      check(_isOpen()).isTrue();

      await tester.tap(find.byType(PlatformCloseButton));
      await pumpTransition(tester);

      check(_isOpen()).isFalse();
      check(await result).isNull();
    });

    scenarioWidgets("asks the route's PopScope before closing it", (tester) async {
      var attempts = 0;
      unawaited(
        _open(
          await pumpForContext(tester),
          page: PopScope<String>(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) attempts++;
            },
            child: _page,
          ),
        ),
      );
      await pumpTransition(tester);

      await tester.tap(find.byType(PlatformCloseButton));
      await pumpTransition(tester);

      check(_isOpen()).isTrue();
      check(attempts).equals(1);
    });

    scenarioWidgets('names itself for screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      unawaited(_open(await pumpForContext(tester)));
      await pumpTransition(tester);
      final name = switch (designLanguage) {
        .material => MaterialLocalizations.of(
          tester.element(find.byKey(_pageKey)),
        ).closeButtonTooltip,
        .cupertino => _label,
      };

      check(buttonsNamed(name).evaluate()).isNotEmpty();
      semantics.dispose();
    });
  });
}

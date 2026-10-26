// Named after what it tests, not after its helper class.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButton;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show IconButton, Icons, TextButton;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _share = 'Share';
const _edit = 'Edit';
const _save = 'Save';
const _custom = 'Custom';

// ignore: no-empty-block, only where the action sits and how it looks matter here.
void _ignore() {}

const _shareAction = PlatformBarAction(label: _share, icon: Icon(Icons.share), onPressed: _ignore);
const _editAction = PlatformBarAction(label: _edit, onPressed: _ignore);
const _saveAction = PlatformBarAction(label: _save, onPressed: _ignore);

// The button each platform's own bar uses for an action: an icon or text button on Material, and on
// Cupertino the flush button cupertino_ui builds its own Cancel with.
class const _OwnBarButton(final PlatformBarAction action) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final content = action.icon ?? Text(action.label);

    return switch (designLanguage) {
      .material =>
        action.icon == null
            ? TextButton(onPressed: _ignore, child: content)
            : IconButton(onPressed: _ignore, icon: content),
      .cupertino => CupertinoButton(padding: EdgeInsets.zero, onPressed: _ignore, child: content),
    };
  }
}

Future<void> _pump(WidgetTester tester, PlatformAppBar bar) =>
    pumpPlatformWidget(tester, PlatformScaffold(appBarData: bar, body: const SizedBox()));

// Where the action's content sits, and the button around it.
({Rect content, Rect button}) _placed(WidgetTester tester, Finder content) => (
  content: tester.getRect(content),
  button: tester.getRect(
    find
        .ancestor(
          of: content,
          matching: find.byWidgetPredicate(
            (widget) => widget is IconButton || widget is TextButton || widget is CupertinoButton,
          ),
        )
        .first,
  ),
);

void main() {
  feature('PlatformAppBar', () {
    scenarioOutlineWidgets<({PlatformBarAction action, Finder content})>(
      "draws each action as the platform's own bar button",
      examples: {
        'an icon': (action: _shareAction, content: find.byIcon(Icons.share)),
        'text': (action: _editAction, content: find.text(_edit)),
      },
      outline: (tester, row) async {
        await _pump(
          tester,
          PlatformAppBar(
            title: const Text('Title'),
            materialAppBarData: MaterialAppBarData(actions: [_OwnBarButton(row.action)]),
            cupertinoNavigationBarData: CupertinoNavigationBarData(
              trailing: _OwnBarButton(row.action),
            ),
          ),
        );
        final own = _placed(tester, row.content);

        await _pump(tester, PlatformAppBar(title: const Text('Title'), actions: [row.action]));

        check(_placed(tester, row.content)).equals(own);
      },
    );

    scenarioWidgets('names an icon action for screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, const PlatformAppBar(actions: [_shareAction]));

      check(buttonsNamed(_share).evaluate()).isNotEmpty();
      semantics.dispose();
    });

    scenarioWidgets('puts the primary action last, at the trailing edge', (tester) async {
      await _pump(
        tester,
        const PlatformAppBar(actions: [_shareAction, _editAction], primaryAction: _saveAction),
      );

      check(tester.getRect(find.text(_save)).left)
          .isGreaterThan(tester.getRect(find.text(_edit)).right);
    });

    scenarioWidgets("sets the primary action's text semibold on iOS", (tester) async {
      await _pump(tester, const PlatformAppBar(actions: [_editAction], primaryAction: _saveAction));

      check(weightOf(labelStyle(tester, _save))).isGreaterThan(weightOf(labelStyle(tester, _edit)));
    }, variant: iosOnly);

    scenarioWidgets('draws the primary action like any other on Android', (tester) async {
      await _pump(tester, const PlatformAppBar(actions: [_editAction], primaryAction: _saveAction));

      check(labelStyle(tester, _save)).equals(labelStyle(tester, _edit));
    }, variant: androidOnly);

    scenarioWidgets('ignores a tap on a disabled action', (tester) async {
      final pressed = <String>[];
      await _pump(
        tester,
        PlatformAppBar(
          actions: [
            PlatformBarAction(
              label: _share,
              icon: const Icon(Icons.share),
              onPressed: () => pressed.add(_share),
              isEnabled: false,
            ),
            PlatformBarAction(label: _edit, onPressed: () => pressed.add(_edit)),
          ],
        ),
      );

      await tester.tap(find.byIcon(Icons.share));
      await tester.tap(find.text(_edit));

      check(pressed).deepEquals([_edit]);
    });

    scenarioOutlineWidgets<DesignLanguage>(
      "lets one platform's own widgets replace its side's actions",
      examples: {'Material': .material, 'Cupertino': .cupertino},
      outline: (tester, overridden) async {
        const custom = Text(_custom);
        await _pump(
          tester,
          PlatformAppBar(
            actions: [_shareAction],
            primaryAction: _saveAction,
            materialAppBarData: overridden == .material
                ? const MaterialAppBarData(actions: [custom])
                : null,
            cupertinoNavigationBarData: overridden == .cupertino
                ? const CupertinoNavigationBarData(trailing: custom)
                : null,
          ),
        );
        final shown = {
          if (find.text(_custom).evaluate().isNotEmpty) _custom,
          if (find.byIcon(Icons.share).evaluate().isNotEmpty) _share,
          if (find.text(_save).evaluate().isNotEmpty) _save,
        };

        check(
          because: designLanguage.name,
          shown,
        ).deepEquals(designLanguage == overridden ? {_custom} : {_share, _save});
      },
    );
  });
}

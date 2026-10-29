// Named after what it tests, not after its helper class.
// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoButton,
        CupertinoLocalizations,
        CupertinoNavigationBarBackButton,
        CupertinoSheetRoute;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart'
    show BackButton, CloseButton, DrawerButton, IconButton, Icons, TextButton, showModalBottomSheet;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _share = 'Share';
const _edit = 'Edit';
const _save = 'Save';
const _custom = 'Custom';
const _first = 'First';
const _drawer = 'Drawer';

const _sheetBody = Key('sheet body');
const _sheetPage = PlatformScaffold(
  appBarData: PlatformAppBar(),
  body: SizedBox(key: _sheetBody),
);

const _shareAction = PlatformBarAction(label: _share, icon: Icon(Icons.share), onPressed: noop);
const _editAction = PlatformBarAction(label: _edit, onPressed: noop);
const _saveAction = PlatformBarAction(label: _save, onPressed: noop);

// The button each platform's own bar uses for an action: an icon or text button on Material, and on
// Cupertino the flush button cupertino_ui builds its own Cancel with.
class const _OwnBarButton(final PlatformBarAction action) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final content = action.icon ?? Text(action.label);

    return switch (designLanguage) {
      .material =>
        action.icon == null
            ? TextButton(onPressed: noop, child: content)
            : IconButton(onPressed: noop, icon: content),
      .cupertino => CupertinoButton(padding: EdgeInsets.zero, onPressed: noop, child: content),
    };
  }
}

Future<void> _pump(WidgetTester tester, PlatformAppBar bar) =>
    pumpPlatformWidget(tester, PlatformScaffold(appBarData: bar, body: const SizedBox()));

// Each platform's own sheet, so these tests don't lean on showPlatformSheet.
Future<void> _openInSheet(WidgetTester tester, Widget page) async {
  final context = await pumpForContext(tester);
  unawaited(switch (designLanguage) {
    .material => showModalBottomSheet<void>(context: context, builder: (_) => page),
    .cupertino => Navigator.of(
      context,
    ).push(CupertinoSheetRoute<void>(scrollableBuilder: (_, _) => page)),
  });
  await tester.pumpAndSettle();
}

Finder _sheetWayOut(WidgetTester tester) => switch (designLanguage) {
  .material => find.byType(CloseButton),
  .cupertino => find.text(
    CupertinoLocalizations.of(tester.element(find.byKey(_sheetBody))).cancelButtonLabel,
  ),
};

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

    scenarioOutlineWidgets<DesignLanguage>(
      "puts one platform's own leading widget on its side only",
      examples: {'Material': .material, 'Cupertino': .cupertino},
      outline: (tester, given) async {
        const custom = Text(_custom);
        await _pump(
          tester,
          PlatformAppBar(
            materialAppBarData: given == .material
                ? const MaterialAppBarData(leading: custom)
                : null,
            cupertinoNavigationBarData: given == .cupertino
                ? const CupertinoNavigationBarData(leading: custom)
                : null,
          ),
        );

        check(
          because: designLanguage.name,
          find.text(_custom).evaluate().isNotEmpty,
        ).equals(designLanguage == given);
      },
    );

    scenarioWidgets("goes back through the platform's own back button", (tester) async {
      await pumpInPlatformScaffold(tester, const Text(_first));
      Navigator.of(tester.element(find.text(_first))).push(
        PageRouteBuilder<void>(
          pageBuilder: (_, _, _) =>
              const PlatformScaffold(appBarData: PlatformAppBar(), body: SizedBox()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(switch (designLanguage) {
        .material => find.byType(BackButton),
        .cupertino => find.byType(CupertinoNavigationBarBackButton),
      });
      await tester.pumpAndSettle();

      check(find.text(_first).evaluate()).isNotEmpty();
    });

    scenarioWidgets("opens the drawer through Material's own drawer button", (tester) async {
      await pumpPlatformWidget(
        tester,
        const PlatformScaffold(
          appBarData: PlatformAppBar(),
          materialScaffoldData: MaterialScaffoldData(drawer: Text(_drawer)),
          body: SizedBox(),
        ),
      );

      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();

      check(find.text(_drawer).evaluate()).isNotEmpty();
    }, variant: androidOnly);

    scenarioWidgets("closes a sheet through the platform's own way out", (tester) async {
      await _openInSheet(tester, _sheetPage);

      await tester.tap(_sheetWayOut(tester));
      await tester.pumpAndSettle();

      check(find.byKey(_sheetBody).evaluate()).isEmpty();
    });

    scenarioWidgets("asks the sheet's PopScope before closing it", (tester) async {
      var attempts = 0;
      await _openInSheet(
        tester,
        PopScope<void>(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) attempts++;
          },
          child: _sheetPage,
        ),
      );

      await tester.tap(_sheetWayOut(tester));
      await tester.pumpAndSettle();

      check(find.byKey(_sheetBody).evaluate()).isNotEmpty();
      check(attempts).equals(1);
    });

    scenarioOutlineWidgets<PlatformAppBar>(
      "lets a sheet's bar swap or drop its way out",
      examples: {
        'swapped for its own leading': const PlatformAppBar(
          materialAppBarData: MaterialAppBarData(leading: Text(_custom)),
          cupertinoNavigationBarData: CupertinoNavigationBarData(leading: Text(_custom)),
        ),
        'dropped': const PlatformAppBar(automaticallyImplyLeading: false),
      },
      outline: (tester, bar) async {
        await _openInSheet(
          tester,
          PlatformScaffold(
            appBarData: bar,
            body: const SizedBox(key: _sheetBody),
          ),
        );
        check(find.byKey(_sheetBody).evaluate()).isNotEmpty();

        check(_sheetWayOut(tester).evaluate()).isEmpty();
      },
    );
  });
}

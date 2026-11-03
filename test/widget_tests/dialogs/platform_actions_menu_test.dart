// Named after what it tests, not after its helper page.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _more = 'More';
const _under = 'Under';
const _share = 'Share';
const _print = 'Print';
const _delete = 'Delete List';
const _confirmMessage = 'Its reminders go too.';
const _shareIcon = Icons.share;
const _printIcon = Icons.print;
const _deleteIcon = Icons.delete;

// The menu's button on top, and another button well clear of the open menu.
class const _Page({
  required final Set<PlatformMenuAction> actions,
  final VoidCallback? onUnderPressed,
}) extends StatelessWidget {
  @override
  // A Stack, not a Column, so a refused menu's error box has room to lay out.
  Widget build(BuildContext context) => Stack(
    children: [
      Align(
        alignment: .topCenter,
        child: PlatformActionsMenu(
          builder: (_, onPressed) =>
              PlatformButton(onPressed: onPressed, emphasis: .medium, child: const Text(_more)),
          actions: actions,
        ),
      ),
      if (onUnderPressed case final onPressed?)
        Align(
          alignment: .bottomCenter,
          child: PlatformButton(onPressed: onPressed, emphasis: .medium, child: const Text(_under)),
        ),
    ],
  );
}

// Share, Print and Delete List. Each notes its label when it runs.
Set<PlatformMenuAction> _actions(List<String> pressedLabels, {bool withIcons = false}) => {
  PlatformMenuAction.normal(
    label: _share,
    iconData: withIcons ? _shareIcon : null,
    onPressed: () => pressedLabels.add(_share),
  ),
  PlatformMenuAction.normal(
    label: _print,
    iconData: withIcons ? _printIcon : null,
    onPressed: () => pressedLabels.add(_print),
  ),
  PlatformMenuAction.delete(
    label: _delete,
    confirmMessage: _confirmMessage,
    iconData: withIcons ? _deleteIcon : null,
    onPressed: () => pressedLabels.add(_delete),
  ),
};

Future<void> _pump(WidgetTester tester, _Page page) => pumpInPlatformScaffold(tester, page);

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

// The actions only exist while the menu is open.
bool _isOpen() => find.text(_share).evaluate().isNotEmpty;

void main() {
  feature('PlatformActionsMenu', () {
    scenarioWidgets('opens from its button and closes on a second press', (tester) async {
      await _pump(tester, _Page(actions: _actions([])));

      await _tap(tester, _more);
      check(_isOpen()).isTrue();

      await _tap(tester, _more);
      check(_isOpen()).isFalse();
    });

    scenarioWidgets('runs a picked action', (tester) async {
      final pressedLabels = <String>[];
      await _pump(tester, _Page(actions: _actions(pressedLabels)));
      await _tap(tester, _more);

      await _tap(tester, _share);

      check(pressedLabels).deepEquals([_share]);
    });

    scenarioWidgets('only closes when tapped outside', (tester) async {
      var underPressCount = 0;
      await _pump(tester, _Page(actions: _actions([]), onUnderPressed: () => underPressCount++));
      await _tap(tester, _more);

      await _tap(tester, _under);

      check(_isOpen()).isFalse();
      check(underPressCount).equals(0);
      // With the menu closed, the same tap reaches the button.
      await _tap(tester, _under);
      check(underPressCount).equals(1);
    });

    // Cupertino's menu takes Escape by itself.
    scenarioWidgets('closes on Escape after a tap opened it', (tester) async {
      await _pump(tester, _Page(actions: _actions([])));
      await _tap(tester, _more);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      check(_isOpen()).isFalse();
    }, variant: androidOnly);

    // A delete and a discard ask the same way.
    scenarioOutlineWidgets<bool>(
      'asks before a destructive action runs',
      examples: {'confirmed': true, 'cancelled': false},
      outline: (tester, runs) async {
        final pressedLabels = <String>[];
        await _pump(tester, _Page(actions: _actions(pressedLabels)));
        await _tap(tester, _more);

        await _tap(tester, _delete);

        check(tester.any(find.text(_confirmMessage))).isTrue();
        check(pressedLabels).isEmpty();

        await _tap(tester, runs ? _delete : 'Cancel');

        check(pressedLabels).deepEquals([if (runs) _delete]);
      },
    );

    scenarioWidgets('draws a destructive action red, with icons after labels, on iOS', (
      tester,
    ) async {
      await _pump(tester, _Page(actions: _actions([], withIcons: true)));
      await _tap(tester, _more);

      check(argbOf(labelStyle(tester, _delete))).equals(CupertinoColors.systemRed.color.toARGB32());
      check(argbOf(labelStyle(tester, _share)))
          .not((shareColor) => shareColor.equals(CupertinoColors.systemRed.color.toARGB32()));
      check(tester.getCenter(find.byIcon(_shareIcon)).dx)
          .isGreaterThan(tester.getCenter(find.text(_share)).dx);
    }, variant: iosOnly);

    scenarioWidgets('keeps every action plain, with icons before labels, on Android', (
      tester,
    ) async {
      await _pump(tester, _Page(actions: _actions([], withIcons: true)));
      await _tap(tester, _more);

      check(argbOf(labelStyle(tester, _delete))).equals(argbOf(labelStyle(tester, _share)));
      check(tester.getCenter(find.byIcon(_shareIcon)).dx)
          .isLessThan(tester.getCenter(find.text(_share)).dx);
    }, variant: androidOnly);

    scenarioOutlineWidgets<Set<PlatformMenuAction>>(
      'refuses a menu the guidelines rule out',
      // The icon rule refuses an empty menu too.
      examples: {
        'with icons on only some actions': {
          _actions([], withIcons: true).first,
          ..._actions([]).skip(1),
        },
        // 2 separate Share actions, which a person couldn't tell apart.
        'with 2 actions sharing a label': {_actions([]).first, _actions([]).first},
      },
      outline: (tester, actions) async {
        await _pump(tester, _Page(actions: actions));

        check(tester.takeException()).isA<AssertionError>();
      },
    );
  });
}

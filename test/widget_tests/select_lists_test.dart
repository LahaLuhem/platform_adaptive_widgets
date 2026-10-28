// Named after what it tests, not after its helper enum.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoCheckbox, CupertinoRadio;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _listKey = Key('list');

// Inside the row on both looks, past the margin iOS leaves around its section.
const _farEndInset = 40.0;

enum _Fruit() {
  apple,
  pear,
  plum,
}

const _picked = _Fruit.pear;

typedef _ListOf = Widget Function({Set<_Fruit>? options, String? header, VoidCallback? onChanged});

final _lists = <String, _ListOf>{
  'single': ({options, header, onChanged}) => PlatformSingleSelectList<_Fruit>(
    options: options ?? _Fruit.values.toSet(),
    selected: _picked,
    label: (fruit) => fruit.name,
    onChanged: (_) => onChanged?.call(),
    header: header,
  ),
  'multi': ({options, header, onChanged}) => PlatformMultiSelectList<_Fruit>(
    options: options ?? _Fruit.values.toSet(),
    selected: const {_picked},
    label: (fruit) => fruit.name,
    onChanged: (_) => onChanged?.call(),
    header: header,
  ),
};

Future<void> _pump(WidgetTester tester, Widget list) =>
    pumpInPlatformScaffold(tester, KeyedSubtree(key: _listKey, child: list));

void main() {
  feature('Select lists', () {
    scenarioOutlineWidgets<_ListOf>(
      "takes a tap at a row's far end, away from its label",
      examples: _lists,
      outline: (tester, listOf) async {
        var taps = 0;
        await _pump(tester, listOf(onChanged: () => taps++));

        await tester.tapAt(
          Offset(
            tester.getRect(find.byKey(_listKey)).right - _farEndInset,
            tester.getCenter(find.text(_Fruit.plum.name)).dy,
          ),
        );
        await tester.pump();

        check(taps).equals(1);
      },
    );

    scenarioOutlineWidgets<_ListOf>(
      "lists the options top to bottom, in the set's order",
      examples: _lists,
      outline: (tester, listOf) async {
        await _pump(tester, listOf());

        final corners = [
          for (final fruit in _Fruit.values) tester.getTopLeft(find.text(fruit.name)),
        ];
        final tops = [for (final corner in corners) corner.dy];

        check(corners.map((corner) => corner.dx).toSet()).length.equals(1);
        check(tops).deepEquals([...tops]..sort());
      },
    );

    scenarioOutlineWidgets<_ListOf>(
      'makes the header a heading for screen readers',
      examples: _lists,
      outline: (tester, listOf) async {
        final semantics = tester.ensureSemantics();
        await _pump(tester, listOf(header: 'Fruit'));

        final header = tester.getSemantics(find.text('Fruit')).getSemanticsData();
        semantics.dispose();

        // Its own node, so the rows aren't read out as part of the heading.
        check(header.label).equals('Fruit');
        check(header.headingLevel).isGreaterThan(0);
      },
    );

    scenarioOutlineWidgets<_ListOf>(
      "flags a selected value that isn't an option",
      examples: _lists,
      outline: (tester, listOf) async {
        await _pump(tester, listOf(options: _Fruit.values.toSet()..remove(_picked)));

        check(tester.takeException()).isA<AssertionError>();
      },
    );

    scenarioOutlineWidgets<_ListOf>(
      "draws iOS's checkmark rows, not the Mac's controls",
      examples: _lists,
      outline: (tester, listOf) async {
        await _pump(tester, listOf());

        check(find.text(_picked.name).evaluate()).isNotEmpty();
        check(
          find
              .byWidgetPredicate(
                (widget) => widget is CupertinoRadio || widget is CupertinoCheckbox,
              )
              .evaluate(),
        ).isEmpty();
      },
      variant: iosOnly,
    );
  });
}

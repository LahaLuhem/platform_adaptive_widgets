// Named after what it tests, not after its helper widget.
// ignore_for_file: prefer-match-file-name

import 'dart:ui' show Tristate;

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoMenuItem, CupertinoPicker;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _icon = Icons.star;
const _leadingIcon = Icons.sort;

// Desktop is where Material's field takes typing.
const _materialDesktop = TargetPlatformVariant({TargetPlatform.windows, TargetPlatform.linux});

String _label(int item) => 'Item $item';

List<int> _items(int count, {int first = 0}) => List.generate(count, (index) => first + index);

class const _Picker({
  required final int count,
  // Shifts the list, so a test can change the items under an open picker.
  final int first = 0,
  final int? current,
  final bool isEnabled = true,
  final bool asIconButton = false,
  final bool withIcons = false,
  final String Function(int item) label = _label,
  final ValueChanged<int>? onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformMenuPicker<int>(
    items: _items(count, first: first),
    currentValue: current,
    isEnabled: isEnabled,
    leadingIcon: const Icon(_leadingIcon),
    labelText: 'Pick',
    onSelected: onSelected,
    menuPickerItemTransformer: (item) =>
        MenuPickerItem(label: label(item), iconData: withIcons ? _icon : null),
    materialMenuPickerData: asIconButton ? const MaterialMenuPickerData.iconButton() : null,
    cupertinoMenuPickerData: asIconButton ? const CupertinoMenuPickerData.iconButton() : null,
  );
}

Future<void> _pump(WidgetTester tester, _Picker picker) =>
    pumpInPlatformScaffold(tester, Center(child: picker));

// Changes the picker the way an app's setState would, under the Navigator. Pumping again from the
// top rebuilds every route as well, which hides an open look going stale.
Future<ValueNotifier<_Picker>> _pumpChangeable(WidgetTester tester, _Picker picker) async {
  final pickerNotifier = ValueNotifier(picker);
  addTearDown(pickerNotifier.dispose);
  await pumpInPlatformScaffold(
    tester,
    Center(
      child: ValueListenableBuilder(
        valueListenable: pickerNotifier,
        builder: (_, picker, _) => picker,
      ),
    ),
  );

  return pickerNotifier;
}

// Taps the icon's spot, not the widget: Material keeps a hidden copy of it, and a disabled field
// can't be hit.
Future<void> _open(WidgetTester tester) async {
  await tester.tapAt(tester.getCenter(find.byIcon(_leadingIcon).first));
  await tester.pumpAndSettle();
}

Future<void> _tapOutside(WidgetTester tester) async {
  await tester.tapAt(const Offset(4, 4));
  await tester.pumpAndSettle();
}

// An open list of choices is a scroll view, whatever the look. The wheel's is a subclass.
int _scrollViews() => find.byWidgetPredicate((widget) => widget is Scrollable).evaluate().length;

// Skips the open list's rows, which sit in a scroll view, and the dropdown's hidden copy, which
// nothing can hit.
bool _fieldShows(String label) =>
    find.text(label).hitTestable().evaluate().any((text) => Scrollable.maybeOf(text) == null);

Finder _listRow(String label) => find.descendant(
  of: find.byWidgetPredicate((widget) => widget is Scrollable),
  matching: find.text(label),
);

// The row in the middle of the open wheel.
int _wheelRow(WidgetTester tester) => tester
    .stateList<ScrollableState>(find.byWidgetPredicate((widget) => widget is Scrollable))
    // As metrics, since the wheel's position is a private subclass that also implements these ones.
    .map<ScrollMetrics>((list) => list.position)
    .whereType<FixedExtentMetrics>()
    .single
    .itemIndex;

bool _rowInView(String label) => find.text(label).evaluate().any((text) {
  final list = Scrollable.maybeOf(text);

  return list != null && _globalRect(list.context).contains(_globalRect(text).center);
});

// The label in the middle of the open wheel, as it's drawn.
String _wheelLabel(WidgetTester tester) {
  final middle = tester.getCenter(find.byType(CupertinoPicker)).dy;
  double offMiddle(Element label) => (_globalRect(label).center.dy - middle).abs();
  final labels = find
      .descendant(of: find.byType(CupertinoPicker), matching: find.byType(Text))
      .evaluate();

  return (labels.reduce((a, b) => offMiddle(a) <= offMiddle(b) ? a : b).widget as Text).data!;
}

Rect _globalRect(BuildContext context) {
  final box = context.findRenderObject()! as RenderBox;

  return box.localToGlobal(Offset.zero) & box.size;
}

// The open menu's row only. The field shows the picked label too.
int _iconsInMenuRow(String label) => find
    .descendant(
      of: find.ancestor(of: find.text(label), matching: find.byType(CupertinoMenuItem)),
      matching: find.byType(Icon),
    )
    .evaluate()
    .length;

void main() {
  feature('PlatformMenuPicker', () {
    scenarioOutlineWidgets<int>(
      'picks from a short list',
      examples: {'with 1 item': 1, 'with 2 items': 2},
      outline: (tester, count) async {
        final picked = <int>[];
        await _pump(tester, _Picker(count: count, onSelected: picked.add));
        check(tester.takeException()).isNull();

        await _open(tester);
        await tester.tap(find.text(_label(count - 1)).hitTestable());
        await tester.pumpAndSettle();

        check(picked).deepEquals([count - 1]);
      },
    );

    scenarioOutlineWidgets<({_Picker picker, bool opens})>(
      'opens when tapped',
      examples: {
        'if it has items': (picker: const _Picker(count: 3), opens: true),
        "unless it's empty": (picker: const _Picker(count: 0), opens: false),
        "unless it's disabled": (picker: const _Picker(count: 3, isEnabled: false), opens: false),
        'as an icon button with items': (
          picker: const _Picker(count: 3, asIconButton: true),
          opens: true,
        ),
        "unless it's an empty icon button": (
          picker: const _Picker(count: 0, asIconButton: true),
          opens: false,
        ),
        "unless it's a disabled icon button": (
          picker: const _Picker(count: 3, isEnabled: false, asIconButton: true),
          opens: false,
        ),
      },
      outline: (tester, row) async {
        await _pump(tester, row.picker);
        check(tester.takeException()).isNull();
        final closed = _scrollViews();

        await _open(tester);

        check(_scrollViews() > closed).equals(row.opens);
      },
    );

    scenarioWidgets('shows nothing picked for a value outside the list', (tester) async {
      await _pump(tester, const _Picker(count: 4, current: 99));

      check(tester.takeException()).isNull();
      check(_items(4).map(_label).where(_fieldShows)).isEmpty();
    });

    scenarioOutlineWidgets<int?>(
      'clears the field when the value moves',
      examples: {'to null': null, 'out of the list': 99},
      outline: (tester, next) async {
        await _pump(tester, const _Picker(count: 4, current: 2));
        check(_fieldShows(_label(2))).isTrue();

        await _pump(tester, _Picker(count: 4, current: next));

        check(tester.takeException()).isNull();
        check(_fieldShows(_label(2))).isFalse();
      },
    );

    // Say the app switched language while the picker was on screen.
    scenarioWidgets("renames the field when the value's label changes", (tester) async {
      await _pump(tester, const _Picker(count: 4, current: 2));
      check(_fieldShows(_label(2))).isTrue();

      await _pump(tester, _Picker(count: 4, current: 2, label: (item) => 'Élément $item'));

      check(_fieldShows('Élément 2')).isTrue();
    });

    scenarioWidgets('keeps showing the value until the app takes a pick', (tester) async {
      final picked = <int>[];
      await _pump(tester, _Picker(count: 4, current: 2, onSelected: picked.add));

      await _open(tester);
      await tester.tap(find.text(_label(3)).hitTestable());
      await tester.pumpAndSettle();

      check(picked).deepEquals([3]);
      check(_fieldShows(_label(2))).isTrue();
      check(_fieldShows(_label(3))).isFalse();
    });

    scenarioOutlineWidgets<({int count, int current, String Function(int item) label})>(
      'opens a long list on the current value',
      examples: {
        'with unique labels': (count: 30, current: 25, label: _label),
        'with another row sharing its label': (
          count: 30,
          current: 25,
          label: (item) => item == 0 || item == 25 ? 'Alex' : _label(item),
        ),
        'on a page of its own': (count: 300, current: 295, label: _label),
      },
      outline: (tester, row) async {
        await _pump(tester, _Picker(count: row.count, current: row.current, label: row.label));

        await _open(tester);

        // The current row can share its label with row 0, so its neighbour tells them apart.
        check(_rowInView(_label(row.current + 1))).isTrue();
        check(_rowInView(_label(1))).isFalse();
      },
    );

    scenarioWidgets('ignores typing in the field', (tester) async {
      await _pump(tester, const _Picker(count: 4, current: 2));

      await _open(tester);
      await tester.enterText(find.byType(EditableText), 'Anything');
      await tester.pumpAndSettle();

      check(_fieldShows('Anything')).isFalse();
    }, variant: _materialDesktop);

    scenarioOutlineWidgets<int>(
      'shows row icons',
      examples: {
        'in a short list': 4,
        'in a list long enough for a wheel': 8,
        'in a list long enough for its own page': 300,
      },
      outline: (tester, count) async {
        await _pump(tester, _Picker(count: count, withIcons: true));

        await _open(tester);

        check(find.byIcon(_icon).evaluate().where((icon) => Scrollable.maybeOf(icon) != null))
            .isNotEmpty();
      },
    );

    scenarioOutlineWidgets<double>(
      "marks a short list's picked row at any text size",
      // iOS's smallest accessibility size sets body text at 28 pt instead of 17.
      examples: {'at the default text size': 1, 'at an accessibility text size': 28 / 17},
      outline: (tester, textScaleFactor) async {
        tester.platformDispatcher.textScaleFactorTestValue = textScaleFactor;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await _pump(tester, const _Picker(count: 3, current: 1, withIcons: true));

        await _open(tester);

        // The checkmark is the one icon its neighbour lacks, whether or not the rows' own icons show.
        check(_iconsInMenuRow(_label(1))).equals(_iconsInMenuRow(_label(0)) + 1);
      },
      variant: iosOnly,
    );

    scenarioOutlineWidgets<int?>(
      'reports nothing when closed without picking',
      examples: {
        'with a value set': 5,
        'with no value set': null,
        'with a value outside the list': 99,
      },
      outline: (tester, current) async {
        final picked = <int>[];
        // Long enough for Cupertino's wheel.
        await _pump(tester, _Picker(count: 8, current: current, onSelected: picked.add));
        final closed = _scrollViews();
        await _open(tester);
        check(_scrollViews()).isGreaterThan(closed);

        await _tapOutside(tester);

        check(picked).isEmpty();
      },
    );

    scenarioWidgets('reports the row the wheel stops on while it stays open', (tester) async {
      final picked = <int>[];
      await _pump(tester, _Picker(count: 8, current: 2, onSelected: picked.add));
      final closed = _scrollViews();
      await _open(tester);

      // Slowly past several rows, so a wheel reporting each row it passes would report more than once.
      await tester.timedDrag(
        _listRow(_label(2)),
        const Offset(0, -120),
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();

      check(_scrollViews()).isGreaterThan(closed);
      check(picked).length.equals(1);
      check(picked.single).not((row) => row.equals(2));
    }, variant: iosOnly);

    // The test's app never takes a pick, so its value stays put.
    scenarioOutlineWidgets<int?>(
      "moves the wheel back when the app doesn't take the pick",
      examples: {'with a value set': 2, 'with no value set': null},
      outline: (tester, current) async {
        final picked = <int>[];
        await _pump(tester, _Picker(count: 8, current: current, onSelected: picked.add));
        await _open(tester);

        await tester.timedDrag(
          _listRow(_label(current ?? 0)),
          const Offset(0, -100),
          const Duration(milliseconds: 300),
        );
        await tester.pumpAndSettle();

        // Reported once: going back isn't a pick.
        check(picked).length.equals(1);
        check(_wheelRow(tester)).equals(current ?? 0);
      },
      variant: iosOnly,
    );

    scenarioWidgets("follows the app's value while the wheel is open", (tester) async {
      final picked = <int>[];
      await _pump(tester, _Picker(count: 8, current: 2, onSelected: picked.add));
      await _open(tester);

      await _pump(tester, _Picker(count: 8, current: 6, onSelected: picked.add));
      await tester.pumpAndSettle();

      check(_wheelRow(tester)).equals(6);
      check(picked).isEmpty();
    }, variant: iosOnly);

    scenarioWidgets("picks the wheel's top row when no value is set", (tester) async {
      final picked = <int>[];
      await _pump(tester, _Picker(count: 8, onSelected: picked.add));
      await _open(tester);

      // Away and back in one slow drag, so the wheel stops on the row it opened on.
      final drag = await tester.startGesture(tester.getCenter(_listRow(_label(0))));
      await drag.moveBy(const Offset(0, -64));
      await tester.pump(const Duration(milliseconds: 100));
      await drag.moveBy(const Offset(0, 64));
      await tester.pump(const Duration(milliseconds: 300));
      await drag.up();
      await tester.pumpAndSettle();

      check(_wheelRow(tester)).equals(0);
      check(picked).deepEquals([0]);
    }, variant: iosOnly);

    scenarioOutlineWidgets<int>(
      'reports nothing when the current value is picked again',
      examples: {'from a menu': 4, 'from a page of its own': 300},
      outline: (tester, count) async {
        final picked = <int>[];
        await _pump(tester, _Picker(count: count, current: 2, onSelected: picked.add));
        final closed = _scrollViews();

        await _open(tester);
        // The field shows the value too, so tap its row in the open list.
        await tester.tap(_listRow(_label(2)));
        await tester.pumpAndSettle();

        check(_scrollViews()).equals(closed);
        check(picked).isEmpty();
      },
    );

    scenarioWidgets("lines up a page row's title with its icon", (tester) async {
      await _pump(tester, const _Picker(count: 300, withIcons: true));

      await _open(tester);

      // Rows build from the top, so row 3's icon is the fourth one.
      check(tester.getCenter(find.text(_label(3))).dy)
          .isCloseTo(tester.getCenter(find.byIcon(_icon).at(3)).dy, 0.5);
    }, variant: iosOnly);

    // 300 is past the cutoff for a page of its own.
    scenarioWidgets('gives a very long list a page of its own', (tester) async {
      await _pump(tester, const _Picker(count: 300));

      await _open(tester);

      // The page covers the screen the picker sits on.
      check(find.byType(PlatformMenuPicker<int>).evaluate()).isEmpty();
    }, variant: iosOnly);

    scenarioWidgets("picks from a very long list's page and goes back", (tester) async {
      final picked = <int>[];
      await _pump(tester, _Picker(count: 300, onSelected: picked.add));

      await _open(tester);
      await tester.tap(find.text(_label(7)).hitTestable());
      await tester.pumpAndSettle();

      check(picked).deepEquals([7]);
      check(find.byType(PlatformMenuPicker<int>).evaluate()).isNotEmpty();
    }, variant: iosOnly);

    scenarioWidgets("tells a screen reader which row of a very long list's page is picked", (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, const _Picker(count: 300, current: 5));

      await _open(tester);
      final picked = tester.getSemantics(_listRow(_label(5))).getSemanticsData();
      final next = tester.getSemantics(_listRow(_label(6))).getSemanticsData();
      semantics.dispose();

      // The row's own title, so VoiceOver reads it with the state, not a run of rows.
      check(picked.label).equals(_label(5));
      check(picked.flagsCollection.isSelected).equals(Tristate.isTrue);
      check(next.flagsCollection.isSelected).not((it) => it.equals(Tristate.isTrue));
    }, variant: iosOnly);

    scenarioWidgets("leaves a very long list's page without a pick", (tester) async {
      final picked = <int>[];
      final semantics = tester.ensureSemantics();
      await _pump(tester, _Picker(count: 300, current: 5, onSelected: picked.add));

      await _open(tester);
      await tester.tap(find.bySemanticsLabel('Back'));
      await tester.pumpAndSettle();
      semantics.dispose();

      check(picked).isEmpty();
      check(find.byType(PlatformMenuPicker<int>).evaluate()).isNotEmpty();
    }, variant: iosOnly);

    scenarioWidgets("reports the item an open wheel stops on after the app's items change", (
      tester,
    ) async {
      final reports = <({int item, String shown})>[];
      void onSelected(int item) => reports.add((item: item, shown: _wheelLabel(tester)));
      final pickerNotifier = await _pumpChangeable(
        tester,
        _Picker(count: 8, current: 2, onSelected: onSelected),
      );
      await _open(tester);

      pickerNotifier.value = _Picker(count: 8, first: 1, current: 2, onSelected: onSelected);
      await tester.pumpAndSettle();
      await tester.timedDrag(
        _listRow(_wheelLabel(tester)),
        const Offset(0, -100),
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();

      check(reports).length.equals(1);
      check(_label(reports.single.item)).equals(reports.single.shown);
    }, variant: iosOnly);

    scenarioWidgets(
      'moves an open wheel to its top row, reporting nothing, when the current value leaves the list',
      (tester) async {
        final picked = <int>[];
        final pickerNotifier = await _pumpChangeable(
          tester,
          _Picker(count: 8, current: 3, onSelected: picked.add),
        );
        await _open(tester);

        pickerNotifier.value = _Picker(count: 8, first: 4, current: 3, onSelected: picked.add);
        await tester.pumpAndSettle();

        check(_wheelRow(tester)).equals(0);
        check(_wheelLabel(tester)).equals(_label(4));
        check(picked).isEmpty();
      },
      variant: iosOnly,
    );

    scenarioWidgets(
      "shows the app's new items on an open page, and marks and reports the ones it shows",
      (tester) async {
        final picked = <int>[];
        final semantics = tester.ensureSemantics();
        final pickerNotifier = await _pumpChangeable(
          tester,
          _Picker(count: 300, current: 5, onSelected: picked.add),
        );
        await _open(tester);

        pickerNotifier.value = _Picker(count: 300, first: 1, current: 5, onSelected: picked.add);
        await tester.pumpAndSettle();
        final pageList = find.byWidgetPredicate((widget) => widget is Scrollable);
        await tester.drag(pageList, const Offset(0, 20000));
        await tester.pumpAndSettle();
        final currentRow = tester.getSemantics(_listRow(_label(5))).getSemanticsData();
        await tester.drag(pageList, const Offset(0, -20000));
        await tester.pumpAndSettle();
        final showsNewLastItem = _listRow(_label(300)).evaluate().isNotEmpty;
        if (showsNewLastItem) {
          await tester.tap(_listRow(_label(300)));
          await tester.pumpAndSettle();
        }
        semantics.dispose();

        check(currentRow.flagsCollection.isSelected).equals(Tristate.isTrue);
        check(showsNewLastItem).isTrue();
        check(picked).deepEquals([300]);
      },
      variant: iosOnly,
    );

    scenarioWidgets(
      "keeps showing the app's items on an open wheel after the count drops into the menu's range",
      (tester) async {
        final pickerNotifier = await _pumpChangeable(tester, const _Picker(count: 8, current: 3));
        await _open(tester);

        pickerNotifier.value = const _Picker(count: 5, first: 2, current: 3);
        await tester.pumpAndSettle();

        check(_listRow(_label(0)).evaluate()).isEmpty();
        check(_wheelLabel(tester)).equals(_label(3));
      },
      variant: iosOnly,
    );

    scenarioWidgets("keeps an open menu open when the count grows past the menu's range", (
      tester,
    ) async {
      final pickerNotifier = await _pumpChangeable(tester, const _Picker(count: 5, current: 1));
      await _open(tester);

      pickerNotifier.value = const _Picker(count: 6, current: 1);
      await tester.pumpAndSettle();

      check(find.byType(CupertinoMenuItem).evaluate()).length.equals(6);
    }, variant: iosOnly);
  });
}

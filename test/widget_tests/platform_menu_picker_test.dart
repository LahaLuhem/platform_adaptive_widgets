// Named after what it tests, not after its helper widget.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _icon = Icons.star;
const _leadingIcon = Icons.sort;

// Material's field only takes typing on desktop, so that's where it could show text that isn't an item.
const _materialDesktop = TargetPlatformVariant({TargetPlatform.windows, TargetPlatform.linux});

String _label(int item) => 'Item $item';

String _sharedLabel(int item) => item == 0 || item == 25 ? 'Alex' : _label(item);

List<int> _items(int count) => List.generate(count, (index) => index);

class const _Picker({
  required final int count,
  final int? current,
  final bool isEnabled = true,
  final bool asIconButton = false,
  final bool withIcons = false,
  final String Function(int item) label = _label,
  final ValueChanged<int>? onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformMenuPicker<int>(
    items: _items(count),
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

// The icon shows in every style. Material lays out a hidden copy too, in the same spot, and a
// disabled field lets taps through, so this taps a place rather than a widget.
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

// The dropdown keeps a hidden copy of its rows to measure itself, which nothing can hit, and the rows
// of an open list sit in a scroll view. What's left is the field.
bool _fieldShows(String label) =>
    find.text(label).hitTestable().evaluate().any((text) => Scrollable.maybeOf(text) == null);

bool _rowInView(String label) => find.text(label).evaluate().any((text) {
  final list = Scrollable.maybeOf(text);

  return list != null && _globalRect(list.context).contains(_globalRect(text).center);
});

Rect _globalRect(BuildContext context) {
  final box = context.findRenderObject()! as RenderBox;

  return box.localToGlobal(Offset.zero) & box.size;
}

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

    scenarioOutlineWidgets<String Function(int item)>(
      'opens a long list on the current value',
      examples: {'with unique labels': _label, 'with another row sharing its label': _sharedLabel},
      outline: (tester, label) async {
        await _pump(tester, _Picker(count: 30, current: 25, label: label));

        await _open(tester);

        // Row 25 can share its label with row 0, so its neighbour tells them apart.
        check(_rowInView(_label(26))).isTrue();
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
      examples: {'in a short list': 4, 'in a list long enough for a wheel': 8},
      outline: (tester, count) async {
        await _pump(tester, _Picker(count: count, withIcons: true));

        await _open(tester);

        check(find.byIcon(_icon).evaluate().where((icon) => Scrollable.maybeOf(icon) != null))
            .isNotEmpty();
      },
    );

    scenarioWidgets('keeps a set value when closed without picking', (tester) async {
      final picked = <int>[];
      // Long enough for Cupertino's wheel.
      await _pump(tester, _Picker(count: 8, current: 5, onSelected: picked.add));
      final closed = _scrollViews();
      await _open(tester);
      check(_scrollViews()).isGreaterThan(closed);

      await _tapOutside(tester);

      check(picked).isEmpty();
    });

    scenarioOutlineWidgets<int?>(
      "picks the wheel's top row when closed",
      examples: {'with no value set': null, 'with a value outside the list': 99},
      outline: (tester, current) async {
        final picked = <int>[];
        await _pump(tester, _Picker(count: 8, current: current, onSelected: picked.add));

        await _open(tester);
        await _tapOutside(tester);

        // A wheel always shows a row, and the top one when it has no value to show.
        check(picked).deepEquals([0]);
      },
      variant: iosOnly,
    );
  });
}

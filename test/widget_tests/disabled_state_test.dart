// Named after what it tests, not after its helper class.
// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoListTile, CupertinoSlider;
import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart' show SemanticsData;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/lib_src.dart';
import '../support/support.dart';

const _label = 'Target';
const _open = 'Open';
const _other = 'Other';

// Room for a slider or a field, which take whatever width they're given.
const _width = 300.0;

bool _named(SemanticsData data) =>
    data.label == _label || data.value == _label || data.tooltip == _label;

// Not by name: an icon's is the package's own label, tested on its own.
bool _isButton(SemanticsData data) => data.flagsCollection.isButton;

Future<void> _tapLabel(WidgetTester tester) =>
    tester.tap(find.text(_label).last, warnIfMissed: false);

Future<void> _tapIcon(WidgetTester tester) =>
    tester.tap(find.byIcon(Icons.share), warnIfMissed: false);

// Opens the picker, then picks the other item if it opened.
Future<void> _pickOtherWith(WidgetTester tester, Finder opener) async {
  await tester.tap(opener, warnIfMissed: false);
  await pumpTransition(tester);
  final other = find.text(_other);
  if (other.evaluate().isNotEmpty) await tester.tap(other.last);
}

/// One way to disable something, built enabled or disabled.
class _Path({
  // The class whose field disables it, for the coverage check.
  required final String owner,
  required final Widget Function({required bool isEnabled, VoidCallback onUse}) screen,
  // The node a screen reader lands on.
  final bool Function(SemanticsData data) target = _named,
  // Whatever has to open before the disabled part shows.
  final Future<void> Function(WidgetTester tester)? open,
  // How a person uses it, reaching `onUse` while enabled.
  final Future<void> Function(WidgetTester tester) use = _tapLabel,
});

class const _InBody(final Widget child) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformScaffold(
    body: Center(
      child: SizedBox(width: _width, child: child),
    ),
  );
}

class const _InBar(final PlatformAppBar bar) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformScaffold(appBarData: bar, body: const SizedBox());
}

Future<void> _openMenu(WidgetTester tester) async {
  await tester.tap(find.text(_open));
  await pumpTransition(tester);
}

final _paths = <String, _Path>{
  'slider': _Path(
    owner: 'PlatformSlider',
    screen: ({required isEnabled, onUse = noop}) =>
        _InBody(PlatformSlider(value: 0.5, onChanged: (_) => onUse(), isEnabled: isEnabled)),
    target: (data) => data.flagsCollection.isSlider,
    use: (tester) =>
        tester.drag(find.byType(PlatformSlider), const Offset(60, 0), warnIfMissed: false),
  ),
  'row': _Path(
    owner: 'PlatformListTile',
    screen: ({required isEnabled, onUse = noop}) =>
        _InBody(PlatformListTile(title: const Text(_label), onTap: onUse, isEnabled: isEnabled)),
  ),
  'multi-select list': _Path(
    owner: 'PlatformMultiSelectList',
    screen: ({required isEnabled, onUse = noop}) => _InBody(
      PlatformMultiSelectList(
        options: const {_label},
        selected: const <String>{},
        label: (option) => option,
        onChanged: (_) => onUse(),
        isEnabled: isEnabled,
      ),
    ),
  ),
  // Picks the row that isn't picked yet, since picking the picked one changes nothing.
  'single-select list': _Path(
    owner: 'PlatformSingleSelectList',
    screen: ({required isEnabled, onUse = noop}) => _InBody(
      PlatformSingleSelectList(
        options: const {_other, _label},
        selected: _other,
        label: (option) => option,
        onChanged: (_) => onUse(),
        isEnabled: isEnabled,
      ),
    ),
  ),
  'switch': _Path(
    owner: 'PlatformSwitch',
    screen: ({required isEnabled, onUse = noop}) =>
        _InBody(PlatformSwitch(value: true, onChanged: (_) => onUse(), isEnabled: isEnabled)),
    target: (data) => data.flagsCollection.isToggled != .none,
    use: (tester) => tester.tap(find.byType(PlatformSwitch), warnIfMissed: false),
  ),
  for (final emphasis in PlatformButtonEmphasis.values) ...{
    'button, ${emphasis.name}': _Path(
      owner: 'PlatformButton',
      screen: ({required isEnabled, onUse = noop}) => _InBody(
        PlatformButton(
          onPressed: onUse,
          emphasis: emphasis,
          isEnabled: isEnabled,
          child: const Text(_label),
        ),
      ),
    ),
    'button, ${emphasis.name}, icon and label': _Path(
      owner: 'PlatformButton',
      screen: ({required isEnabled, onUse = noop}) => _InBody(
        PlatformButton.icon(
          onPressed: onUse,
          emphasis: emphasis,
          isEnabled: isEnabled,
          icon: const Icon(Icons.share),
          label: const Text(_label),
        ),
      ),
    ),
    'button, ${emphasis.name}, icon only': _Path(
      owner: 'PlatformButton',
      screen: ({required isEnabled, onUse = noop}) => _InBody(
        PlatformButton.iconOnly(
          onPressed: onUse,
          emphasis: emphasis,
          isEnabled: isEnabled,
          icon: const Icon(Icons.share),
          label: _label,
        ),
      ),
      target: _isButton,
      use: _tapIcon,
    ),
  },
  'text field': _Path(
    owner: 'PlatformTextField',
    screen: ({required isEnabled, onUse = noop}) =>
        _InBody(PlatformTextField(hintText: _label, onTap: onUse, isEnabled: isEnabled)),
    target: (data) => data.flagsCollection.isTextField,
  ),
  'search bar': _Path(
    owner: 'PlatformSearchBar',
    screen: ({required isEnabled, onUse = noop}) => _InBody(
      PlatformSearchBar(
        onChanged: (_) => noop(),
        onTap: onUse,
        hintText: _label,
        isEnabled: isEnabled,
      ),
    ),
    target: (data) => data.flagsCollection.isTextField,
  ),
  'menu picker': _Path(
    owner: 'PlatformMenuPicker',
    screen: ({required isEnabled, onUse = noop}) => _InBody(
      PlatformMenuPicker<String>(
        items: const {_label, _other},
        currentValue: _label,
        onSelected: (_) => onUse(),
        isEnabled: isEnabled,
      ),
    ),
    use: (tester) => _pickOtherWith(tester, find.text(_label)),
  ),
  'menu picker, icon button': _Path(
    owner: 'PlatformMenuPicker',
    screen: ({required isEnabled, onUse = noop}) => _InBody(
      PlatformMenuPicker<String>(
        items: const {_label, _other},
        leadingIcon: const Icon(Icons.sort),
        onSelected: (_) => onUse(),
        isEnabled: isEnabled,
        materialMenuPickerData: const MaterialMenuPickerData.iconButton(),
        cupertinoMenuPickerData: const CupertinoMenuPickerData.iconButton(),
      ),
    ),
    target: _isButton,
    use: (tester) => _pickOtherWith(tester, find.byIcon(Icons.sort)),
  ),
  'bar action': _Path(
    owner: 'PlatformBarAction',
    screen: ({required isEnabled, onUse = noop}) => _InBar(
      PlatformAppBar(
        primaryAction: PlatformBarAction(label: _label, onPressed: onUse, isEnabled: isEnabled),
      ),
    ),
  ),
  'bar action, icon': _Path(
    owner: 'PlatformBarAction',
    screen: ({required isEnabled, onUse = noop}) => _InBar(
      PlatformAppBar(
        actions: [
          PlatformBarAction(
            label: _label,
            icon: const Icon(Icons.share),
            onPressed: onUse,
            isEnabled: isEnabled,
          ),
        ],
      ),
    ),
    target: _isButton,
    use: _tapIcon,
  ),
  'actions menu item': _Path(
    owner: 'PlatformMenuAction',
    screen: ({required isEnabled, onUse = noop}) => _InBody(
      PlatformActionsMenu(
        builder: (_, onPressed) => GestureDetector(onTap: onPressed, child: const Text(_open)),
        actions: {PlatformMenuAction.normal(label: _label, onPressed: onUse, isEnabled: isEnabled)},
      ),
    ),
    open: _openMenu,
  ),
};

// Kept out of _paths, since iOS still offers screen readers a tap on it. See 'until upstream' below.
final _segment = _Path(
  owner: 'PlatformSegmentButton',
  screen: ({required isEnabled, onUse = noop}) => _InBody(
    PlatformSegmentButton<String>(
      choices: const {_other, _label},
      segmentBuilder: Text.new,
      selectedChoice: _other,
      onSelectionChanged: (_) => onUse(),
      disabledChildren: {if (!isEnabled) _label},
    ),
  ),
);

// Each has its own row under 'until upstream' below.
const _noLookOnIos = {'slider', 'row', 'multi-select list', 'single-select list', 'search bar'};

// iOS draws every shape through one button.
final _buttonIconShapes = {
  for (final emphasis in PlatformButtonEmphasis.values) ...{
    'button, ${emphasis.name}, icon and label',
    'button, ${emphasis.name}, icon only',
  },
};

Map<String, _Path> _where(bool Function(String name) keep) =>
    Map.fromEntries(_paths.entries.where((path) => keep(path.key)));

Future<void> _pump(
  WidgetTester tester,
  _Path path, {
  required bool isEnabled,
  VoidCallback onUse = noop,
}) async {
  // A fresh tree, so nothing carries over from the other state, like an open menu.
  await tester.pumpWidget(const SizedBox());
  await pumpPlatformWidget(tester, path.screen(isEnabled: isEnabled, onUse: onUse));
  await pumpTransition(tester);
  await path.open?.call(tester);
}

/// How many times using [path] reached its callback.
Future<int> _usesOf(WidgetTester tester, _Path path, {required bool isEnabled}) async {
  var uses = 0;
  await _pump(tester, path, isEnabled: isEnabled, onUse: () => uses++);
  await path.use(tester);
  await pumpTransition(tester);

  return uses;
}

/// Whether disabling [path] changes how the screen looks.
Future<bool> _disablingShows(WidgetTester tester, _Path path) async {
  await _pump(tester, path, isEnabled: true);
  final enabled = await pixelsOf(tester, find.byType(PlatformApp));
  await _pump(tester, path, isEnabled: false);
  final disabled = await pixelsOf(tester, find.byType(PlatformApp));

  return !listEquals(enabled.rgba, disabled.rgba);
}

Future<List<SemanticsData>> _disabledTargets(WidgetTester tester, _Path path) async {
  final semantics = tester.ensureSemantics();
  await _pump(tester, path, isEnabled: false);
  final targets = find.semantics
      .byPredicate((node) => path.target(node.getSemanticsData()))
      .evaluate()
      .map((node) => node.getSemanticsData())
      .toList(growable: false);
  semantics.dispose();

  return targets;
}

Future<void> _looksDisabled(WidgetTester tester, _Path path) async =>
    check(await _disablingShows(tester, path)).isTrue();

Future<void> _saysDisabled(WidgetTester tester, _Path path) async {
  final targets = await _disabledTargets(tester, path);

  check(targets).isNotEmpty();
  check(targets).every(
    (target) => target
      ..has((data) => data.flagsCollection.isEnabled, 'enabled').equals(.isFalse)
      ..has((data) => data.hasAction(.tap), 'tap').isFalse(),
  );
}

void main() {
  final disabledState = BddFeature('Disabled state');

  Bdd(disabledState)
      .scenario('looks disabled')
      .runOutlineWidgets<_Path>(
        examples: {..._paths, 'segment': _segment},
        outline: _looksDisabled,
        variant: androidOnly,
      );

  Bdd(disabledState)
      .scenario('looks disabled')
      .runOutlineWidgets<_Path>(
        examples: {
          ..._where((name) => !_noLookOnIos.contains(name) && !_buttonIconShapes.contains(name)),
          'segment': _segment,
        },
        outline: _looksDisabled,
        variant: iosOnly,
      );

  // Material says it by itself. 'looks disabled' covers the wiring.
  Bdd(disabledState)
      .scenario('tells screen readers it is disabled')
      .runOutlineWidgets<_Path>(examples: _paths, outline: _saysDisabled, variant: iosOnly);

  // Used enabled first, so a tap that misses can't pass.
  Bdd(disabledState)
      .scenario('ignores a tap while disabled')
      .runOutlineWidgets<_Path>(
        examples: {..._paths, 'segment': _segment},
        outline: (tester, path) async {
          check(because: 'enabled', await _usesOf(tester, path, isEnabled: true)).isGreaterThan(0);
          check(because: 'disabled', await _usesOf(tester, path, isEnabled: false)).equals(0);
        },
        variant: iosOnly,
      );

  Bdd(disabledState)
      .scenario('tells screen readers a disabled segment is disabled')
      .runWidgets((tester) async {
        final [segment] = await _disabledTargets(tester, _segment);

        check(segment.flagsCollection.isEnabled).equals(.isFalse);
      }, variant: iosOnly);

  Bdd(disabledState)
      .scenario("keeps a widget's state when it's disabled")
      .runWidgets((tester) async {
        // The slider stands in for every path that disables through the package's own wrapper.
        final slider = _paths['slider']!;
        await pumpPlatformWidget(tester, slider.screen(isEnabled: true));
        final enabled = tester.state(find.byType(CupertinoSlider));
        await pumpPlatformWidget(tester, slider.screen(isEnabled: false));

        check(tester.state(find.byType(CupertinoSlider))).identicalTo(enabled);
      }, variant: iosOnly);

  test('covers every public class with a field that disables something', () {
    final owners = parsedLibSrc
        .expand(
          (unit) => unit.ast.declarations.whereType<ClassDeclaration>().where(unit.barrelExports),
        )
        .where(
          (declaration) =>
              instanceFieldNames(declaration)
                  .intersection(const {'isEnabled', 'disabledChildren'})
                  .isNotEmpty,
        )
        .map((declaration) => declaration.namePart.typeName.lexeme)
        .where((name) => !name.startsWith('_'));

    check(
      because: 'A class that can disable something needs a row here.',
      owners,
    ).unorderedEquals({..._paths.values.map((path) => path.owner), _segment.owner});
  });

  final untilUpstream = BddFeature('Disabled state, until upstream');

  Bdd(untilUpstream)
      .scenario('draws no disabled look on iOS')
      .runOutlineWidgets<({_Path path, String issue})>(
        examples: {
          'slider': (
            path: _paths['slider']!,
            issue: 'https://github.com/flutter/flutter/issues/106691',
          ),
          'search bar': (
            path: _paths['search bar']!,
            issue: 'https://github.com/LahaLuhem/platform_adaptive_widgets/issues/71',
          ),
        },
        outline: (tester, gap) async => check(
          because:
              'Upstream draws it now (${gap.issue}). Move it to "looks disabled", and drop any note '
              'on its `isEnabled`.',
          await _disablingShows(tester, gap.path),
        ).isFalse(),
        variant: iosOnly,
      );

  test("a CupertinoListTile can't be disabled", () {
    check(
      because:
          'It takes `enabled` now (https://github.com/flutter/flutter/issues/195327). Pass it, move '
          'the row and the select lists to "looks disabled", and drop the notes on their `isEnabled`.',
      // Throws on a named argument it doesn't take.
      () => Function.apply(CupertinoListTile.new, const [], {
        #title: const Text(_label),
        #enabled: false,
      }),
    ).throws<NoSuchMethodError>();
  });

  Bdd(untilUpstream)
      .scenario('a disabled segment still offers screen readers a tap on iOS')
      .runWidgets((tester) async {
        final [segment] = await _disabledTargets(tester, _segment);

        check(
          because:
              'Upstream drops it now (https://github.com/flutter/flutter/issues/195515). Move the '
              'segment into "tells screen readers it is disabled".',
          segment.hasAction(.tap),
        ).isTrue();
      }, variant: iosOnly);

  Bdd(untilUpstream)
      .scenario('a disabled slider gives screen readers no value on iOS')
      .runWidgets((tester) async {
        final [slider] = await _disabledTargets(tester, _paths['slider']!);

        check(
          because:
              'Upstream keeps it now (https://github.com/flutter/packages/pull/12710). Drop this '
              'check.',
          slider.value,
        ).isEmpty();
      }, variant: iosOnly);
}

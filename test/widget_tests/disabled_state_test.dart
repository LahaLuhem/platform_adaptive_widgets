// Named after what it tests, not after its helper class.
// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoListTile;
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

// Room for a slider or a field, which take whatever width they're given.
const _width = 300.0;

// ignore: no-empty-block, a disabled widget never calls it.
void _ignore([Object? _]) {}

bool _named(SemanticsData data) =>
    data.label == _label || data.value == _label || data.tooltip == _label;

/// One way to disable something, built enabled or disabled.
class _Path({
  // The class whose field disables it, for the coverage check.
  required final String owner,
  required final Widget Function({required bool isEnabled}) screen,
  // The node a screen reader lands on.
  final bool Function(SemanticsData data) target = _named,
  // Whatever has to open before the disabled part shows.
  final Future<void> Function(WidgetTester tester)? open,
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
  await tester.pumpAndSettle();
}

final _paths = <String, _Path>{
  'slider': _Path(
    owner: 'PlatformSlider',
    screen: ({required isEnabled}) =>
        _InBody(PlatformSlider(value: 0.5, onChanged: _ignore, isEnabled: isEnabled)),
    target: (data) => data.flagsCollection.isSlider,
  ),
  'row': _Path(
    owner: 'PlatformListTile',
    screen: ({required isEnabled}) =>
        _InBody(PlatformListTile(title: const Text(_label), onTap: _ignore, isEnabled: isEnabled)),
  ),
  'switch': _Path(
    owner: 'PlatformSwitch',
    screen: ({required isEnabled}) =>
        _InBody(PlatformSwitch(value: true, onChanged: _ignore, isEnabled: isEnabled)),
    target: (data) => data.flagsCollection.isToggled != .none,
  ),
  for (final emphasis in PlatformButtonEmphasis.values) ...{
    'button, ${emphasis.name}': _Path(
      owner: 'PlatformButton',
      screen: ({required isEnabled}) => _InBody(
        PlatformButton(
          onPressed: _ignore,
          emphasis: emphasis,
          isEnabled: isEnabled,
          child: const Text(_label),
        ),
      ),
    ),
    'button, ${emphasis.name}, icon and label': _Path(
      owner: 'PlatformButton',
      screen: ({required isEnabled}) => _InBody(
        PlatformButton.icon(
          onPressed: _ignore,
          emphasis: emphasis,
          isEnabled: isEnabled,
          icon: const Icon(Icons.share),
          label: const Text(_label),
        ),
      ),
    ),
    'button, ${emphasis.name}, icon only': _Path(
      owner: 'PlatformButton',
      screen: ({required isEnabled}) => _InBody(
        PlatformButton.iconOnly(
          onPressed: _ignore,
          emphasis: emphasis,
          isEnabled: isEnabled,
          icon: const Icon(Icons.share),
          label: _label,
        ),
      ),
    ),
  },
  'text field': _Path(
    owner: 'PlatformTextField',
    screen: ({required isEnabled}) =>
        _InBody(PlatformTextField(hintText: _label, isEnabled: isEnabled)),
    target: (data) => data.flagsCollection.isTextField,
  ),
  'search bar': _Path(
    owner: 'PlatformSearchBar',
    screen: ({required isEnabled}) =>
        _InBody(PlatformSearchBar(onChanged: _ignore, hintText: _label, isEnabled: isEnabled)),
    target: (data) => data.flagsCollection.isTextField,
  ),
  'menu picker': _Path(
    owner: 'PlatformMenuPicker',
    screen: ({required isEnabled}) => _InBody(
      PlatformMenuPicker<String>(
        items: const [_label],
        currentValue: _label,
        onSelected: _ignore,
        isEnabled: isEnabled,
      ),
    ),
  ),
  'menu picker, icon button': _Path(
    owner: 'PlatformMenuPicker',
    screen: ({required isEnabled}) => _InBody(
      PlatformMenuPicker<String>(
        items: const [_label],
        leadingIcon: const Icon(Icons.sort),
        onSelected: _ignore,
        isEnabled: isEnabled,
        materialMenuPickerData: const MaterialMenuPickerData.iconButton(),
        cupertinoMenuPickerData: const CupertinoMenuPickerData.iconButton(),
      ),
    ),
    target: (data) => data.flagsCollection.isButton,
  ),
  'bar action': _Path(
    owner: 'PlatformBarAction',
    screen: ({required isEnabled}) => _InBar(
      PlatformAppBar(
        primaryAction: PlatformBarAction(label: _label, onPressed: _ignore, isEnabled: isEnabled),
      ),
    ),
  ),
  'bar action, icon': _Path(
    owner: 'PlatformBarAction',
    screen: ({required isEnabled}) => _InBar(
      PlatformAppBar(
        actions: [
          PlatformBarAction(
            label: _label,
            icon: const Icon(Icons.share),
            onPressed: _ignore,
            isEnabled: isEnabled,
          ),
        ],
      ),
    ),
  ),
  'actions menu item': _Path(
    owner: 'PlatformMenuAction',
    screen: ({required isEnabled}) => _InBody(
      PlatformActionsMenu(
        builder: (_, onPressed) => GestureDetector(onTap: onPressed, child: const Text(_open)),
        actions: {
          PlatformMenuAction.normal(label: _label, onPressed: _ignore, isEnabled: isEnabled),
        },
      ),
    ),
    open: _openMenu,
  ),
};

// Only Cupertino can disable a single segment.
final _segment = _Path(
  owner: 'CupertinoSegmentButtonData',
  screen: ({required isEnabled}) => _InBody(
    PlatformSegmentButton<String>(
      choices: const ['Other', _label],
      segmentBuilder: Text.new,
      selectedChoice: 'Other',
      onSelectionChanged: _ignore,
      cupertinoSegmentButtonData: CupertinoSegmentButtonData(
        disabledChildren: {if (!isEnabled) _label},
      ),
    ),
  ),
);

// Each has its own row under 'until upstream' below.
const _noLookOnIos = {'slider', 'row', 'search bar'};

const _toldOnIos = {'switch', 'text field', 'search bar', 'actions menu item'};

Map<String, _Path> _where(bool Function(String name) keep) =>
    Map.fromEntries(_paths.entries.where((path) => keep(path.key)));

Future<void> _pump(WidgetTester tester, _Path path, {required bool isEnabled}) async {
  // A fresh tree, so nothing carries over from the other state, like an open menu.
  await tester.pumpWidget(const SizedBox());
  await pumpPlatformWidget(tester, path.screen(isEnabled: isEnabled));
  await tester.pumpAndSettle();
  await path.open?.call(tester);
}

Future<Uint8List> _screen(WidgetTester tester) async {
  final image = (await tester.runAsync(
    () => captureImage(tester.element(find.byType(PlatformApp))),
  ))!;
  final bytes = (await tester.runAsync(image.toByteData))!.buffer.asUint8List();
  image.dispose();

  return bytes;
}

/// Whether disabling [path] changes how the screen looks.
Future<bool> _disablingShows(WidgetTester tester, _Path path) async {
  await _pump(tester, path, isEnabled: true);
  final enabled = await _screen(tester);
  await _pump(tester, path, isEnabled: false);

  return !listEquals(enabled, await _screen(tester));
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
  feature('Disabled state', () {
    scenarioOutlineWidgets<_Path>(
      'looks disabled',
      examples: _paths,
      outline: _looksDisabled,
      variant: androidOnly,
    );

    scenarioOutlineWidgets<_Path>(
      'looks disabled',
      examples: {..._where((name) => !_noLookOnIos.contains(name)), 'segment': _segment},
      outline: _looksDisabled,
      variant: iosOnly,
    );

    scenarioOutlineWidgets<_Path>(
      'tells screen readers it is disabled',
      examples: _paths,
      outline: _saysDisabled,
      variant: androidOnly,
    );

    scenarioOutlineWidgets<_Path>(
      'tells screen readers it is disabled',
      examples: _where(_toldOnIos.contains),
      outline: _saysDisabled,
      variant: iosOnly,
    );

    test('covers every class with a field that disables something', () {
      final owners = libSrcUnits
          .expand((unit) => unit.parsed.unit.declarations.whereType<ClassDeclaration>())
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
  });

  feature('Disabled state, until upstream', () {
    scenarioOutlineWidgets<({_Path path, String issue})>(
      'draws no disabled look on iOS',
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
        because: 'Upstream draws it now (${gap.issue}). Move it to "looks disabled".',
        await _disablingShows(tester, gap.path),
      ).isFalse(),
      variant: iosOnly,
    );

    test("a CupertinoListTile can't be disabled", () {
      check(
        because:
            'It takes `enabled` now (https://github.com/flutter/flutter/issues/195327). Pass it, and '
            'move the row to "looks disabled".',
        // Throws on a named argument it doesn't take.
        () => Function.apply(CupertinoListTile.new, const [], {
          #title: const Text(_label),
          #enabled: false,
        }),
      ).throws<NoSuchMethodError>();
    });

    scenarioWidgets('a disabled slider gives screen readers no value on iOS', (tester) async {
      final [slider] = await _disabledTargets(tester, _paths['slider']!);

      check(
        because:
            'Upstream keeps it now (https://github.com/flutter/packages/pull/12710). Drop this '
            'check.',
        slider.value,
      ).isEmpty();
    }, variant: iosOnly);
  });
}

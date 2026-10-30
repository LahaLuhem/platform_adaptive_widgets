// AOT timings for doc/costs.md, which says how to run them.

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart'
    show kDefaultCupertinoSliderThumbColor;

const _repeats = 50000;

const _rounds = 9;

/// Keeps every result in use, so the compiler can't drop a call.
var _sink = 0;

final _report = <String>[];

void main() {
  // The first pass overlaps app start-up, so only the second one reports.
  _timeAll(report: false);
  _timeAll(report: true);
  _log('bench done ($_sink)');
  // On screen too, since a release build on an iPhone may not reach `flutter run`'s log.
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(child: ListView(children: [for (final line in _report) Text(line)])),
      ),
    ),
  );
}

void _log(String line) {
  _report.add(line);
  print(line);
}

void _timeAll({required bool report}) {
  _time('cursor radius', const Radius.circular(3), report: report, {
    'copy': _radiusCopy,
    'read': _radiusRead,
    'allocate': _radiusAllocate,
  });
  _time('slider thumb', const Color(0xFF000000), report: report, {
    'copy': _thumbCopy,
    'read': _thumbRead,
    'allocate': _thumbAllocate,
  });
  _time<EditableTextContextMenuBuilder>('menu builder', _copiedMenu, report: report, {
    'copy': _menuCopy,
    'read': _menuRead,
    'allocate': _menuAllocate,
  });
}

void _time<T>(String group, T given, Map<String, T Function(T?)> variants, {required bool report}) {
  // Mostly the fallback, with `given` mixed in so the compiler can't assume either.
  final inputs = List<T?>.generate(1000, (index) => index % 10 == 0 ? given : null);
  double nanosPerCall(T Function(T?) resolve) {
    final stopwatch = Stopwatch()..start();
    for (var repeat = 0; repeat < _repeats; repeat++) {
      for (final input in inputs) {
        _sink += identityHashCode(resolve(input)) & 1;
      }
    }

    return stopwatch.elapsedMicroseconds * 1000 / (_repeats * inputs.length);
  }

  variants.values.forEach(nanosPerCall);
  if (!report) return;
  final timings = {for (final name in variants.keys) name: <double>[]};
  // The variants take turns, so a slowdown partway through hits them all alike.
  for (var round = 0; round < _rounds; round++) {
    variants.forEach((name, resolve) => timings[name]!.add(nanosPerCall(resolve)));
  }
  timings.forEach((name, runs) {
    runs.sort();
    _log(
      'bench $group, $name: median ${runs[_rounds ~/ 2].toStringAsFixed(2)} ns/call, '
      'range ${runs.first.toStringAsFixed(2)} to ${runs.last.toStringAsFixed(2)}',
    );
  });
}

// Not inlined, so each is timed as the call the package makes.

@pragma('vm:never-inline')
Radius _radiusCopy(Radius? given) => given ?? const Radius.circular(2);

@pragma('vm:never-inline')
Radius _radiusRead(Radius? given) => given ?? const CupertinoTextField().cursorRadius;

@pragma('vm:never-inline')
Radius _radiusAllocate(Radius? given) => given ?? Radius.circular(2);

@pragma('vm:never-inline')
Color _thumbCopy(Color? given) => given ?? kDefaultCupertinoSliderThumbColor;

@pragma('vm:never-inline')
Color _thumbRead(Color? given) =>
    given ?? const CupertinoSlider(value: 0, onChanged: null).thumbColor;

@pragma('vm:never-inline')
Color _thumbAllocate(Color? given) => given ?? Color(0xFFFFFFFF);

/// Stands in for a copied builder. Only picking it is timed, not calling it.
Widget _copiedMenu(BuildContext context, EditableTextState editableTextState) =>
    AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState);

@pragma('vm:never-inline')
EditableTextContextMenuBuilder _menuCopy(EditableTextContextMenuBuilder? given) =>
    given ?? _copiedMenu;

@pragma('vm:never-inline')
EditableTextContextMenuBuilder _menuRead(EditableTextContextMenuBuilder? given) =>
    given ?? const TextField().contextMenuBuilder!;

@pragma('vm:never-inline')
EditableTextContextMenuBuilder _menuAllocate(EditableTextContextMenuBuilder? given) =>
    given ?? (context, editableTextState) => _copiedMenu(context, editableTextState);

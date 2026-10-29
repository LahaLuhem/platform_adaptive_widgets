// Named after what it tests, not after its helper enum.
// ignore_for_file: prefer-match-file-name

import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoButton, CupertinoColors, CupertinoThemeData;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons, Material;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _label = 'Save';

const _icon = Icons.save;

// Below this, a fill or an outline reads as gray. M3's grays keep a trace of the theme's hue.
const _grayChromaLimit = 0.07;

const _destructiveKinds = {PlatformActionKind.delete, PlatformActionKind.discard};

final _emphases = {for (final emphasis in PlatformButtonEmphasis.values) emphasis.name: emphasis};

// What sits behind the label, which is how M3 and the HIG both rank buttons.
enum _Backdrop() {
  accent,
  tint,
  gray,
  none,
}

// The 3 ways to build one. Material builds each from its own class or factory.
enum _Shape() {
  child,
  iconAndLabel,
  iconOnly,
}

typedef _Drawn = ({Color? fill, Color? outline, Color content});

class const _Button(
  final PlatformButtonEmphasis emphasis, {
  final _Shape shape = .child,
  final PlatformActionKind actionKind = .normal,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => switch (shape) {
    .child => PlatformButton(
      onPressed: noop,
      emphasis: emphasis,
      actionKind: actionKind,
      child: const Text(_label),
    ),
    .iconAndLabel => PlatformButton.icon(
      onPressed: noop,
      emphasis: emphasis,
      actionKind: actionKind,
      icon: const Icon(_icon),
      label: const Text(_label),
    ),
    .iconOnly => PlatformButton.iconOnly(
      onPressed: noop,
      emphasis: emphasis,
      actionKind: actionKind,
      icon: const Icon(_icon),
      label: _label,
    ),
  };
}

Future<void> _pump(
  WidgetTester tester,
  _Button button, {
  CupertinoThemeData? cupertinoTheme,
}) async {
  await tester.pumpWidget(
    PlatformApp(
      cupertinoAppData: CupertinoAppData(theme: cupertinoTheme),
      home: PlatformScaffold(body: Center(child: button)),
    ),
  );
  // Material eases a label into its new color.
  await tester.pumpAndSettle();
}

// A plain copy: a Cupertino color never equals a plain one, and can't print once its button is gone.
Color _plain(Color color) => Color(color.toARGB32());

({Color? color, ShapeBorder? shape}) _surface(WidgetTester tester) {
  switch (designLanguage) {
    case .material:
      final material = tester.widget<Material>(
        find.descendant(of: find.byType(PlatformButton), matching: find.byType(Material)).first,
      );

      return (color: material.color, shape: material.shape);
    case .cupertino:
      final box = tester.widget<DecoratedBox>(
        find
            .descendant(of: find.byType(CupertinoButton), matching: find.byType(DecoratedBox))
            .first,
      );
      final decoration = box.decoration as ShapeDecoration;

      return (color: decoration.color, shape: decoration.shape);
  }
}

// A clear color draws nothing.
Color? _shown(Color? color) => color == null || color.a == 0 ? null : _plain(color);

_Drawn _drawn(WidgetTester tester) {
  final surface = _surface(tester);
  final shape = surface.shape;
  final outline = shape is OutlinedBorder && shape.side.style != .none ? shape.side.color : null;

  return (
    fill: _shown(surface.color),
    outline: _shown(outline),
    // The first glyph on it: the icon where there is one, or else the label.
    content: _plain(
      tester
          .widget<RichText>(
            find.descendant(of: find.byType(PlatformButton), matching: find.byType(RichText)).first,
          )
          .text
          .style!
          .color!,
    ),
  );
}

// How much color it adds over a white page.
double _chroma(Color color) {
  final channels = [color.r, color.g, color.b];

  return (channels.reduce(math.max) - channels.reduce(math.min)) * color.a;
}

_Backdrop _backdrop(WidgetTester tester) {
  final drawn = _drawn(tester);
  final accent = _plain(PlatformTheme.of(tester.element(find.byType(PlatformButton))).primaryColor);

  return switch (drawn.fill ?? drawn.outline) {
    null => .none,
    final color when color == accent => .accent,
    final color when _chroma(color) < _grayChromaLimit => .gray,
    _ => .tint,
  };
}

void main() {
  feature('PlatformButton', () {
    scenarioOutlineWidgets<({PlatformButtonEmphasis emphasis, _Backdrop backdrop})>(
      'draws each emphasis the same way on both platforms',
      examples: {
        'high: the accent': (emphasis: .high, backdrop: .accent),
        'medium: a light colored fill': (emphasis: .medium, backdrop: .tint),
        'mediumNeutral: a gray fill or outline': (emphasis: .mediumNeutral, backdrop: .gray),
        'low: nothing': (emphasis: .low, backdrop: .none),
      },
      outline: (tester, row) async {
        for (final shape in _Shape.values) {
          await _pump(tester, _Button(row.emphasis, shape: shape));

          check(because: shape.name, _backdrop(tester)).equals(row.backdrop);
        }
      },
    );

    scenarioOutlineWidgets<PlatformButtonEmphasis>(
      'draws a destructive action as if the accent were red on iOS',
      examples: _emphases,
      outline: (tester, emphasis) async {
        for (final shape in _Shape.values) {
          await _pump(
            tester,
            _Button(emphasis, shape: shape),
            cupertinoTheme: const CupertinoThemeData(primaryColor: CupertinoColors.systemRed),
          );
          final harmlessInRed = _drawn(tester);

          for (final actionKind in _destructiveKinds) {
            await _pump(tester, _Button(emphasis, shape: shape, actionKind: actionKind));

            check(
              because: '${shape.name}, ${actionKind.name}',
              _drawn(tester),
            ).equals(harmlessInRed);
          }
        }
      },
      variant: iosOnly,
    );

    scenarioOutlineWidgets<PlatformButtonEmphasis>(
      'keeps a destructive action plain on Android',
      examples: _emphases,
      outline: (tester, emphasis) async {
        for (final shape in _Shape.values) {
          await _pump(tester, _Button(emphasis, shape: shape));
          final harmless = _drawn(tester);

          for (final actionKind in _destructiveKinds) {
            await _pump(tester, _Button(emphasis, shape: shape, actionKind: actionKind));

            check(because: '${shape.name}, ${actionKind.name}', _drawn(tester)).equals(harmless);
          }
        }
      },
      variant: androidOnly,
    );

    scenarioOutlineWidgets<PlatformButtonEmphasis>(
      'names an icon-only button for screen readers on both platforms',
      examples: _emphases,
      outline: (tester, emphasis) async {
        final semantics = tester.ensureSemantics();
        await _pump(tester, _Button(emphasis, shape: .iconOnly));

        check(buttonsNamed(_label).evaluate()).isNotEmpty();
        semantics.dispose();
      },
    );
  });
}

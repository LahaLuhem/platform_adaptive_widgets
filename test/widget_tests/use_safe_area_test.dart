@TestOn('vm')
library;

import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoNavigationBar;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show AppBar;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/lib_src.dart';
import '../support/support.dart';

const _bodyKey = Key('body');
const _homeKey = Key('home');
const _body = SizedBox.expand(key: _bodyKey);
const _phone = Size(390, 844);
const _statusBarHeight = 47.0;
const _homeIndicatorHeight = 34.0;

typedef _Open = Future<void> Function(WidgetTester tester);

const _pageBar = PlatformAppBar(title: Text('Title'));

PlatformAppBarData _bar(BuildContext _) => _pageBar;

// A phone with a status bar and a home indicator, so the body has an inset to keep clear of at each end.
Future<void> _pumpPhone(WidgetTester tester, Widget home) {
  final view = tester.view;
  view.physicalSize = _phone * view.devicePixelRatio;
  view.padding = FakeViewPadding(
    top: _statusBarHeight * view.devicePixelRatio,
    bottom: _homeIndicatorHeight * view.devicePixelRatio,
  );
  addTearDown(view.reset);

  return pumpPlatformWidget(tester, home);
}

Future<void> _openOver(WidgetTester tester, void Function(BuildContext context) open) async {
  await _pumpPhone(tester, const SizedBox(key: _homeKey));
  open(tester.element(find.byKey(_homeKey)));
}

// Each entry point taking useSafeArea, opened without it and with it.
final _entryPoints = <String, ({_Open byDefault, _Open withSafeArea})>{
  'PlatformScaffold': (
    byDefault: (tester) =>
        _pumpPhone(tester, const PlatformScaffold(appBarData: _pageBar, body: _body)),
    withSafeArea: (tester) => _pumpPhone(
      tester,
      const PlatformScaffold(appBarData: _pageBar, useSafeArea: true, body: _body),
    ),
  ),
  'showPlatformSheet': (
    byDefault: (tester) => _openOver(
      tester,
      (context) => unawaited(
        showPlatformSheet<void>(context: context, appBarBuilder: _bar, builder: (_) => _body),
      ),
    ),
    withSafeArea: (tester) => _openOver(
      tester,
      (context) => unawaited(
        showPlatformSheet<void>(
          context: context,
          appBarBuilder: _bar,
          useSafeArea: true,
          builder: (_) => _body,
        ),
      ),
    ),
  ),
  'showPlatformFullscreenDialog': (
    byDefault: (tester) => _openOver(
      tester,
      (context) => unawaited(
        showPlatformFullscreenDialog<void>(
          context: context,
          appBarBuilder: _bar,
          builder: (_) => _body,
        ),
      ),
    ),
    withSafeArea: (tester) => _openOver(
      tester,
      (context) => unawaited(
        showPlatformFullscreenDialog<void>(
          context: context,
          appBarBuilder: _bar,
          useSafeArea: true,
          builder: (_) => _body,
        ),
      ),
    ),
  ),
};

final _byDefault = {
  for (final MapEntry(:key, :value) in _entryPoints.entries) key: value.byDefault,
};

final _withSafeArea = {
  for (final MapEntry(:key, :value) in _entryPoints.entries) key: value.withSafeArea,
};

Future<({Rect body, Rect bar})> _rectsAfter(WidgetTester tester, _Open open) async {
  await open(tester);
  await pumpTransition(tester);

  return (
    body: tester.getRect(find.byKey(_bodyKey)),
    bar: tester.getRect(
      find.byType(switch (designLanguage) {
        .material => AppBar,
        .cupertino => CupertinoNavigationBar,
      }).last,
    ),
  );
}

// A useSafeArea that defaults to kDefaultUseSafeArea, the body's own flag, not a route's.
bool _takesSafeArea(CompilationUnitMember declaration) =>
    switch (declaration) {
      FunctionDeclaration(:final functionExpression) => functionExpression.parameters?.parameters,
      ClassDeclaration(namePart: PrimaryConstructorDeclaration(:final formalParameters)) =>
        formalParameters.parameters,
      _ => null,
    }?.any(
      (parameter) =>
          parameter.name?.lexeme == 'useSafeArea' &&
          parameter.defaultClause?.value.toSource() == 'kDefaultUseSafeArea',
    ) ??
    false;

String _nameOf(CompilationUnitMember declaration) => switch (declaration) {
  ClassDeclaration(:final namePart) => namePart.typeName.lexeme,
  FunctionDeclaration(:final name) => name.lexeme,
  _ => declaration.toSource(),
};

void main() {
  feature('useSafeArea', () {
    scenarioOutlineWidgets<_Open>(
      'keeps the body clear of the home indicator',
      examples: _withSafeArea,
      outline: (tester, open) async {
        final rects = await _rectsAfter(tester, open);

        check(rects.body.bottom).isLessOrEqual(_phone.height - _homeIndicatorHeight);
      },
    );

    // Material's scaffold lays the body out below its bar by itself.
    scenarioOutlineWidgets<_Open>(
      'keeps the body clear of the bar on iOS',
      examples: _withSafeArea,
      outline: (tester, open) async {
        final rects = await _rectsAfter(tester, open);

        check(rects.body.top).isGreaterOrEqual(rects.bar.bottom);
      },
      variant: iosOnly,
    );

    scenarioOutlineWidgets<_Open>(
      'leaves the body down to the bottom edge without it, so a list can scroll under it',
      examples: _byDefault,
      outline: (tester, open) async {
        final rects = await _rectsAfter(tester, open);

        check(rects.body.bottom).equals(_phone.height);
      },
    );

    scenarioOutlineWidgets<_Open>(
      'leaves the body under the bar without it on iOS',
      examples: _byDefault,
      outline: (tester, open) async {
        final rects = await _rectsAfter(tester, open);

        check(rects.body.top).isLessThan(rects.bar.bottom);
      },
      variant: iosOnly,
    );

    test('covers every entry point that takes useSafeArea', () {
      final entryPoints = parsedLibSrc
          .expand((unit) => unit.ast.declarations.where(unit.barrelExports))
          .where(_takesSafeArea)
          .map(_nameOf);

      check(
        because: 'An entry point taking useSafeArea needs a row here.',
        entryPoints,
      ).unorderedEquals(_entryPoints.keys);
    });
  });
}

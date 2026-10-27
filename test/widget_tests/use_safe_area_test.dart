import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoNavigationBar;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show AppBar;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

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

final _byDefault = <String, _Open>{
  'a page': (tester) =>
      _pumpPhone(tester, const PlatformScaffold(appBarData: _pageBar, body: _body)),
  'a sheet': (tester) => _openOver(
    tester,
    (context) => unawaited(
      showPlatformSheet<void>(context: context, appBarBuilder: _bar, builder: (_) => _body),
    ),
  ),
  'a full-screen dialog': (tester) => _openOver(
    tester,
    (context) => unawaited(
      showPlatformFullscreenDialog<void>(
        context: context,
        appBarBuilder: _bar,
        builder: (_) => _body,
      ),
    ),
  ),
};

final _withSafeArea = <String, _Open>{
  'a page': (tester) => _pumpPhone(
    tester,
    const PlatformScaffold(appBarData: _pageBar, useSafeArea: true, body: _body),
  ),
  'a sheet': (tester) => _openOver(
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
  'a full-screen dialog': (tester) => _openOver(
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
};

Rect _barRect(WidgetTester tester) => tester.getRect(
  find.byType(switch (designLanguage) {
    .material => AppBar,
    .cupertino => CupertinoNavigationBar,
  }).last,
);

void main() {
  feature('useSafeArea', () {
    scenarioOutlineWidgets<_Open>(
      'keeps a body that does not scroll clear of the bar and the home indicator',
      examples: _withSafeArea,
      outline: (tester, open) async {
        await open(tester);
        await tester.pumpAndSettle();
        final body = tester.getRect(find.byKey(_bodyKey));

        check(body.top).isGreaterOrEqual(_barRect(tester).bottom);
        check(body.bottom).isLessOrEqual(_phone.height - _homeIndicatorHeight);
      },
    );

    scenarioOutlineWidgets<_Open>(
      'leaves the body edge to edge without it, so a list can scroll under the bars',
      examples: _byDefault,
      outline: (tester, open) async {
        await open(tester);
        await tester.pumpAndSettle();

        check(tester.getRect(find.byKey(_bodyKey)).bottom).equals(_phone.height);
      },
    );
  });
}

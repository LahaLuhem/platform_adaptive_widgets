import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show AppBar, BottomSheet, CloseButton;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _bodyKey = Key('body');
const _fieldKey = Key('field');
const _save = 'Save';
const _saved = 'saved';
const _message = 'Discard this list?';
const _discard = 'Discard List';
const _phone = Size(390, 844);
const _keyboardHeight = 336.0;
const _statusBarHeight = 47.0;

// Taller than the room a keyboard leaves, with the field at its foot.
const _lowField = SizedBox(
  key: _bodyKey,
  height: 600,
  child: Align(
    alignment: .bottomCenter,
    child: PlatformTextField(key: _fieldKey),
  ),
);

final _longList = ListView(
  key: _bodyKey,
  children: [for (var row = 0; row < 20; row++) SizedBox(height: 48, child: Text('Row $row'))],
);

// A phone, so the sheet, the keyboard and a long list share a phone's room.
Future<BuildContext> _pumpPhone(
  WidgetTester tester, {
  Widget home = const SizedBox(),
  double statusBarHeight = 0,
}) async {
  final view = tester.view;
  view.physicalSize = _phone * view.devicePixelRatio;
  view.padding = FakeViewPadding(top: statusBarHeight * view.devicePixelRatio);
  addTearDown(view.reset);
  await pumpPlatformWidget(tester, home);

  return tester.element(find.byType(SizedBox).last);
}

PlatformAppBarData _titleBar(BuildContext _) => const PlatformAppBar(title: Text('New list'));

PlatformAppBarData _saveBar(BuildContext context) => PlatformAppBar(
  primaryAction: PlatformBarAction(
    label: _save,
    onPressed: () => Navigator.maybeOf(context)?.pop(_saved),
  ),
);

Future<String?> _open(
  BuildContext context, {
  Widget body = const SizedBox(key: _bodyKey, height: 200),
  PlatformAppBarData Function(BuildContext context)? appBarBuilder = _titleBar,
  PlatformUnsavedChanges? unsavedChanges,
}) => showPlatformSheet<String>(
  context: context,
  appBarBuilder: appBarBuilder,
  builder: (_) => body,
  unsavedChanges: unsavedChanges,
);

PlatformUnsavedChanges _guard(bool Function() hasChanges) =>
    PlatformUnsavedChanges(hasChanges: hasChanges, message: _message, discardLabel: _discard);

bool _isUp() => find.byKey(_bodyKey).evaluate().isNotEmpty;

bool _isAsking() => find.text(_message).evaluate().isNotEmpty;

// Each bar adds its own way out. An open ask brings a second Cancel above the sheet, so the bar's is
// the first one and the ask's the last.
Finder _wayOut(WidgetTester tester) => switch (designLanguage) {
  .material => find.byType(CloseButton),
  .cupertino => find.text(cancelLabel(tester.element(find.byKey(_bodyKey)))).first,
};

Finder _askCancel(WidgetTester tester) =>
    find.text(cancelLabel(tester.element(find.byKey(_bodyKey)))).last;

Future<double> _sheetHeightAround(WidgetTester tester, double bodyHeight) async {
  unawaited(
    _open(
      await _pumpPhone(tester),
      body: SizedBox(key: _bodyKey, height: bodyHeight),
    ),
  );
  await pumpTransition(tester);
  final height = tester.getSize(find.byType(BottomSheet)).height;
  await tester.pumpWidget(const SizedBox());

  return height;
}

/// The pixel at [point], in physical pixels, as RGBA packed into one int.
int _rgbaAt(({Uint8List rgba, int width}) pixels, Offset point) =>
    ByteData.sublistView(pixels.rgba)
        .getUint32((point.dy.round() * pixels.width + point.dx.round()) * 4);

void main() {
  feature('showPlatformSheet', () {
    scenarioWidgets("closes with null through its bar's own way out", (tester) async {
      final result = _open(await _pumpPhone(tester));
      await pumpTransition(tester);
      check(_isUp()).isTrue();

      await tester.tap(_wayOut(tester));
      await pumpTransition(tester);

      check(_isUp()).isFalse();
      check(await result).isNull();
    });

    scenarioWidgets('closes with the value of a Save in its bar', (tester) async {
      // go_router's tab branches are nested navigators, while the sheet goes on the root one.
      final context = await _pumpPhone(
        tester,
        home: Navigator(
          onGenerateRoute: (_) =>
              PageRouteBuilder<void>(pageBuilder: (_, _, _) => const SizedBox()),
        ),
      );
      final result = _open(context, appBarBuilder: _saveBar);
      await pumpTransition(tester);

      await tester.tap(find.text(_save));
      await pumpTransition(tester);

      // Closed first, or the result never comes.
      check(_isUp()).isFalse();
      check(await result).equals(_saved);
    });

    scenarioWidgets('keeps a low text field above the keyboard', (tester) async {
      unawaited(_open(await _pumpPhone(tester), body: _lowField));
      await pumpTransition(tester);
      final keyboardTop = _phone.height - _keyboardHeight;
      // Low enough for the keyboard to cover it, or the last check proves nothing.
      check(tester.getRect(find.byKey(_fieldKey)).bottom).isGreaterThan(keyboardTop);

      tester.view.viewInsets = FakeViewPadding(
        bottom: _keyboardHeight * tester.view.devicePixelRatio,
      );
      await pumpTransition(tester);

      check(tester.getRect(find.byKey(_fieldKey)).bottom).isLessOrEqual(keyboardTop);
    });

    scenarioWidgets('sizes an Android sheet to its content', (tester) async {
      final short = await _sheetHeightAround(tester, 100);
      final tall = await _sheetHeightAround(tester, 300);

      check(tall - short).equals(200);
    }, variant: androidOnly);

    scenarioWidgets("draws an Android sheet's bar on the sheet's own color", (tester) async {
      unawaited(_open(await _pumpPhone(tester)));
      await pumpTransition(tester);
      final bar = tester.getRect(find.byType(AppBar));
      final body = tester.getRect(find.byKey(_bodyKey));

      final pixels = await pixelsOf(tester, find.byType(PlatformApp));
      final ratio = tester.view.devicePixelRatio;

      // Past the title, where the bar draws nothing of its own.
      final barColor = _rgbaAt(pixels, Offset(bar.right - 16, bar.center.dy) * ratio);
      final bodyColor = _rgbaAt(pixels, body.center * ratio);

      check(barColor).equals(bodyColor);
    }, variant: androidOnly);

    scenarioWidgets('opens a long Android sheet up to the status bar', (tester) async {
      final context = await _pumpPhone(tester, statusBarHeight: _statusBarHeight);
      unawaited(_open(context, body: _longList));
      await pumpTransition(tester);

      check(tester.getRect(find.byType(BottomSheet)).top).equals(_statusBarHeight);
    }, variant: androidOnly);

    scenarioWidgets('still gives an iOS sheet without a bar its Cancel', (tester) async {
      final result = _open(await _pumpPhone(tester), appBarBuilder: null);
      await pumpTransition(tester);
      check(find.text(cancelLabel(tester.element(find.byKey(_bodyKey)))).evaluate()).isNotEmpty();

      await tester.tap(_wayOut(tester));
      await pumpTransition(tester);

      check(_isUp()).isFalse();
      check(await result).isNull();
    }, variant: iosOnly);

    scenarioWidgets("shows M3's plain sheet on Android without a bar", (tester) async {
      unawaited(_open(await _pumpPhone(tester), appBarBuilder: null));
      await pumpTransition(tester);

      check(_isUp()).isTrue();
      check(find.byType(AppBar).evaluate()).isEmpty();
    }, variant: androidOnly);

    scenarioWidgets('asks before Back closes it with unsaved changes', (tester) async {
      unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => true)));
      await pumpTransition(tester);

      await tester.binding.handlePopRoute();
      await pumpTransition(tester);

      check(_isAsking()).isTrue();
      check(_isUp()).isTrue();
    });

    scenarioWidgets('asks before its scrim closes it with unsaved changes', (tester) async {
      unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => true)));
      await pumpTransition(tester);

      await tester.tapAt(const Offset(4, 4));
      await pumpTransition(tester);

      check(_isAsking()).isTrue();
      check(_isUp()).isTrue();
    }, variant: androidOnly);

    scenarioWidgets('stays up when the person keeps their changes', (tester) async {
      unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => true)));
      await pumpTransition(tester);
      await tester.tap(_wayOut(tester));
      await pumpTransition(tester);

      await tester.tap(_askCancel(tester));
      await pumpTransition(tester);

      check(_isAsking()).isFalse();
      check(_isUp()).isTrue();
    });

    scenarioWidgets('closes with null when the person discards their changes', (tester) async {
      final result = _open(await _pumpPhone(tester), unsavedChanges: _guard(() => true));
      await pumpTransition(tester);
      await tester.tap(_wayOut(tester));
      await pumpTransition(tester);

      await tester.tap(find.text(_discard));
      await pumpTransition(tester);

      check(_isUp()).isFalse();
      check(await result).isNull();
    });

    scenarioWidgets('asks about changes made after it opened', (tester) async {
      var hasChanges = false;
      unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => hasChanges)));
      await pumpTransition(tester);
      // The person types something.
      hasChanges = true;

      await tester.tap(_wayOut(tester));
      await pumpTransition(tester);

      check(_isAsking()).isTrue();
    });

    scenarioWidgets('closes at once when nothing is unsaved', (tester) async {
      unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => false)));
      await pumpTransition(tester);

      await tester.tap(_wayOut(tester));
      await pumpTransition(tester);

      check(_isAsking()).isFalse();
      check(_isUp()).isFalse();
    });

    scenarioWidgets("closes with a Save's value without asking", (tester) async {
      final result = _open(
        await _pumpPhone(tester),
        appBarBuilder: _saveBar,
        unsavedChanges: _guard(() => true),
      );
      await pumpTransition(tester);

      await tester.tap(find.text(_save));
      await pumpTransition(tester);

      check(_isAsking()).isFalse();
      check(await result).equals(_saved);
    });

    scenarioOutlineWidgets<PlatformUnsavedChanges?>(
      'closes on a fling down, unless that would drop unsaved changes',
      examples: {'without a guard': null, 'with unsaved changes': _guard(() => true)},
      outline: (tester, unsavedChanges) async {
        unawaited(_open(await _pumpPhone(tester), unsavedChanges: unsavedChanges));
        await pumpTransition(tester);

        await tester.flingFrom(tester.getCenter(find.byKey(_bodyKey)), const Offset(0, 500), 2000);
        await pumpTransition(tester);

        // The unguarded row proves the fling is strong enough to close a sheet.
        check(_isUp()).equals(unsavedChanges != null);
      },
    );
  });
}

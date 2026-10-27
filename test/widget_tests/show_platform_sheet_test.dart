import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLocalizations;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart'
    show AppBar, BottomSheet, CloseButton, MaterialLocalizations;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

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

bool _isUp(WidgetTester tester) => tester.any(find.byKey(_bodyKey));

bool _isAsking(WidgetTester tester) => tester.any(find.text(_message));

// Each bar adds its own way out. An open ask brings a second Cancel above the sheet, so the bar's is
// the first one and the ask's the last.
Finder _wayOut(WidgetTester tester) => switch (designLanguage) {
  .material => find.byType(CloseButton),
  .cupertino =>
    find
        .text(CupertinoLocalizations.of(tester.element(find.byKey(_bodyKey))).cancelButtonLabel)
        .first,
};

Finder _askCancel(WidgetTester tester) {
  final context = tester.element(find.byKey(_bodyKey));

  return find.text(switch (designLanguage) {
    .material => MaterialLocalizations.of(context).cancelButtonLabel,
    .cupertino => CupertinoLocalizations.of(context).cancelButtonLabel,
  }).last;
}

void main() {
  feature('showPlatformSheet', () {
    scenarioWidgets("closes with null through its bar's own way out", (tester) async {
      final result = _open(await _pumpPhone(tester));
      await tester.pumpAndSettle();
      check(_isUp(tester)).isTrue();

      await tester.tap(_wayOut(tester));
      await tester.pumpAndSettle();

      check(_isUp(tester)).isFalse();
      check(await result).isNull();
    });

    scenarioOutlineWidgets<bool>(
      'closes with the value of a Save in its bar',
      examples: {'opened from the root navigator': false, 'opened from a nested one': true},
      outline: (tester, isNested) async {
        // go_router's tab branches are nested navigators, while the sheet goes on the root one.
        final context = await _pumpPhone(
          tester,
          home: isNested
              ? Navigator(
                  onGenerateRoute: (_) =>
                      PageRouteBuilder<void>(pageBuilder: (_, _, _) => const SizedBox()),
                )
              : const SizedBox(),
        );
        final result = _open(context, appBarBuilder: _saveBar);
        await tester.pumpAndSettle();

        await tester.tap(find.text(_save));
        await tester.pumpAndSettle();

        // Closed first, or the result never comes.
        check(_isUp(tester)).isFalse();
        check(await result).equals(_saved);
      },
    );

    scenarioWidgets('keeps a low text field above the keyboard', (tester) async {
      unawaited(_open(await _pumpPhone(tester), body: _lowField));
      await tester.pumpAndSettle();
      final keyboardTop = _phone.height - _keyboardHeight;
      // Low enough for the keyboard to cover it, or the last check proves nothing.
      check(tester.getRect(find.byKey(_fieldKey)).bottom).isGreaterThan(keyboardTop);

      tester.view.viewInsets = FakeViewPadding(
        bottom: _keyboardHeight * tester.view.devicePixelRatio,
      );
      await tester.pumpAndSettle();

      check(tester.getRect(find.byKey(_fieldKey)).bottom).isLessOrEqual(keyboardTop);
    });

    scenarioWidgets('sizes an Android sheet to its content', (tester) async {
      Future<double> sheetHeightAround(double bodyHeight) async {
        unawaited(
          _open(
            await _pumpPhone(tester),
            body: SizedBox(key: _bodyKey, height: bodyHeight),
          ),
        );
        await tester.pumpAndSettle();
        final height = tester.getSize(find.byType(BottomSheet)).height;
        await tester.pumpWidget(const SizedBox());

        return height;
      }

      final short = await sheetHeightAround(100);
      final tall = await sheetHeightAround(300);

      check(tall - short).equals(200);
    }, variant: androidOnly);

    scenarioWidgets("draws an Android sheet's bar on the sheet's own color", (tester) async {
      unawaited(_open(await _pumpPhone(tester)));
      await tester.pumpAndSettle();
      final bar = tester.getRect(find.byType(AppBar));
      final body = tester.getRect(find.byKey(_bodyKey));

      final image = (await tester.runAsync(
        () => captureImage(tester.element(find.byType(PlatformApp))),
      ))!;
      final pixels = (await tester.runAsync(image.toByteData))!;
      int colorAt(Offset point) {
        final ratio = tester.view.devicePixelRatio;

        // Raw RGBA, 4 bytes a pixel.
        return pixels.getUint32(
          ((point.dy * ratio).round() * image.width + (point.dx * ratio).round()) * 4,
        );
      }

      // Past the title, where the bar draws nothing of its own.
      final barColor = colorAt(Offset(bar.right - 16, bar.center.dy));
      final bodyColor = colorAt(body.center);
      image.dispose();

      check(barColor).equals(bodyColor);
    }, variant: androidOnly);

    scenarioWidgets('opens a long Android sheet up to the status bar, with no overflow', (
      tester,
    ) async {
      final context = await _pumpPhone(tester, statusBarHeight: _statusBarHeight);
      unawaited(_open(context, body: _longList));
      await tester.pumpAndSettle();

      check(tester.takeException()).isNull();
      final sheet = tester.getRect(find.byType(BottomSheet));
      check(sheet.top).equals(_statusBarHeight);
      check(sheet.bottom).equals(_phone.height);
    }, variant: androidOnly);

    scenarioWidgets('still gives an iOS sheet without a bar its Cancel', (tester) async {
      final result = _open(await _pumpPhone(tester), appBarBuilder: null);
      await tester.pumpAndSettle();

      await tester.tap(_wayOut(tester));
      await tester.pumpAndSettle();

      check(_isUp(tester)).isFalse();
      check(await result).isNull();
    }, variant: iosOnly);

    scenarioWidgets("shows M3's plain sheet on Android without a bar, closed by its scrim", (
      tester,
    ) async {
      final result = _open(await _pumpPhone(tester), appBarBuilder: null);
      await tester.pumpAndSettle();
      check(tester.any(find.byType(AppBar))).isFalse();

      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();

      check(_isUp(tester)).isFalse();
      check(await result).isNull();
    }, variant: androidOnly);

    scenarioOutlineWidgets<Future<void> Function(WidgetTester tester)>(
      'asks before closing with unsaved changes',
      examples: {
        "through its bar's way out": (tester) => tester.tap(_wayOut(tester)),
        'through Back': (tester) => tester.binding.handlePopRoute(),
      },
      outline: (tester, leave) async {
        unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => true)));
        await tester.pumpAndSettle();

        await leave(tester);
        await tester.pumpAndSettle();

        check(_isAsking(tester)).isTrue();
        check(_isUp(tester)).isTrue();
      },
    );

    scenarioWidgets('asks before its scrim closes it with unsaved changes', (tester) async {
      unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => true)));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();

      check(_isAsking(tester)).isTrue();
      check(_isUp(tester)).isTrue();
    }, variant: androidOnly);

    scenarioWidgets('stays up when the person keeps their changes', (tester) async {
      unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => true)));
      await tester.pumpAndSettle();
      await tester.tap(_wayOut(tester));
      await tester.pumpAndSettle();

      await tester.tap(_askCancel(tester));
      await tester.pumpAndSettle();

      check(_isAsking(tester)).isFalse();
      check(_isUp(tester)).isTrue();
    });

    scenarioWidgets('closes with null when the person discards their changes', (tester) async {
      final result = _open(await _pumpPhone(tester), unsavedChanges: _guard(() => true));
      await tester.pumpAndSettle();
      await tester.tap(_wayOut(tester));
      await tester.pumpAndSettle();

      await tester.tap(find.text(_discard));
      await tester.pumpAndSettle();

      check(_isUp(tester)).isFalse();
      check(await result).isNull();
    });

    scenarioWidgets('asks about changes made after it opened', (tester) async {
      var hasChanges = false;
      unawaited(_open(await _pumpPhone(tester), unsavedChanges: _guard(() => hasChanges)));
      await tester.pumpAndSettle();
      // The person types something.
      hasChanges = true;

      await tester.tap(_wayOut(tester));
      await tester.pumpAndSettle();

      check(_isAsking(tester)).isTrue();
    });

    scenarioWidgets('closes at once when nothing is unsaved', (tester) async {
      final result = _open(await _pumpPhone(tester), unsavedChanges: _guard(() => false));
      await tester.pumpAndSettle();

      await tester.tap(_wayOut(tester));
      await tester.pumpAndSettle();

      check(_isAsking(tester)).isFalse();
      check(_isUp(tester)).isFalse();
      check(await result).isNull();
    });

    scenarioWidgets("closes with a Save's value without asking", (tester) async {
      final result = _open(
        await _pumpPhone(tester),
        appBarBuilder: _saveBar,
        unsavedChanges: _guard(() => true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(_save));
      await tester.pumpAndSettle();

      check(_isAsking(tester)).isFalse();
      check(await result).equals(_saved);
    });

    scenarioOutlineWidgets<PlatformUnsavedChanges?>(
      'closes on a fling down, unless that would drop unsaved changes',
      examples: {'without a guard': null, 'with unsaved changes': _guard(() => true)},
      outline: (tester, unsavedChanges) async {
        unawaited(_open(await _pumpPhone(tester), unsavedChanges: unsavedChanges));
        await tester.pumpAndSettle();

        await tester.flingFrom(tester.getCenter(find.byKey(_bodyKey)), const Offset(0, 500), 2000);
        await tester.pumpAndSettle();

        // The unguarded row proves the fling is strong enough to close a sheet.
        check(_isUp(tester)).equals(unsavedChanges != null);
      },
    );
  });
}

// Named after what it tests, not after its helper class.
// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoActivityIndicator,
        CupertinoButton,
        CupertinoNavigationBarBackButton,
        CupertinoSheetRoute;
import 'package:flutter/semantics.dart' show SemanticsData;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart'
    show
        BackButton,
        CloseButton,
        IconButton,
        Icons,
        ProgressIndicator,
        TextButton,
        showModalBottomSheet;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_adaptive_widgets/src/models/layout/platform_bar_action.dart'
    show kBarActionBusyDelay;

import '../../support/support.dart';

const _share = 'Share';
const _edit = 'Edit';
const _save = 'Save';
const _scan = 'Scan';
const _publish = 'Publish';
const _custom = 'Custom';
const _first = 'First';

const _sheetBody = Key('sheet body');
const _sheetPage = PlatformScaffold(
  appBarData: PlatformAppBar(),
  body: SizedBox(key: _sheetBody),
);

const _shareAction = PlatformBarAction(label: _share, icon: Icon(Icons.share), onPressed: noop);
const _editAction = PlatformBarAction(label: _edit, onPressed: noop);
const _saveAction = PlatformBarAction(label: _save, onPressed: noop);

// The button each platform's own bar uses for an action: an icon or text button on Material, and on
// Cupertino the flush button cupertino_ui builds its own Cancel with.
class const _OwnBarButton(final PlatformBarAction action) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final content = action.icon ?? Text(action.label);

    return switch (designLanguage) {
      .material =>
        action.icon == null
            ? TextButton(onPressed: noop, child: content)
            : IconButton(onPressed: noop, icon: content),
      .cupertino => CupertinoButton(padding: EdgeInsets.zero, onPressed: noop, child: content),
    };
  }
}

Future<void> _pump(WidgetTester tester, PlatformAppBar bar) =>
    pumpPlatformWidget(tester, PlatformScaffold(appBarData: bar, body: const SizedBox()));

// Each platform's own sheet, so these tests don't lean on showPlatformSheet.
Future<void> _openInSheet(WidgetTester tester, Widget page) async {
  final context = await pumpForContext(tester);
  unawaited(switch (designLanguage) {
    .material => showModalBottomSheet<void>(context: context, builder: (_) => page),
    .cupertino => Navigator.of(
      context,
    ).push(CupertinoSheetRoute<void>(scrollableBuilder: (_, _) => page)),
  });
  await pumpTransition(tester);
}

Finder _sheetWayOut(WidgetTester tester) => switch (designLanguage) {
  .material => find.byType(CloseButton),
  .cupertino => find.text(cancelLabel(tester.element(find.byKey(_sheetBody)))),
};

Finder _buttonOf(Finder content) => find
    .ancestor(
      of: content,
      matching: find.byWidgetPredicate(
        (widget) => widget is IconButton || widget is TextButton || widget is CupertinoButton,
      ),
    )
    .first;

// Where the action's content sits, and the button around it.
({Rect content, Rect button}) _placed(WidgetTester tester, Finder content) =>
    (content: tester.getRect(content), button: tester.getRect(_buttonOf(content)));

// An action's work, which a scenario ends by hand. The next pump runs pending microtasks first, so the
// bar sees the end before it draws.
final class _Work() {
  final _runs = <Completer<void>>[];

  int get starts => _runs.length;

  Future<void> run() {
    final runCompleter = Completer<void>();
    _runs.add(runCompleter);

    return runCompleter.future;
  }

  void end() => _runs.last.complete();

  void fail(Object error) => _runs.last.completeError(error);
}

typedef _Kind = ({String label, Widget? icon, Finder content});

// Each look draws an icon action and a text one through different buttons.
final _Kind _iconKind = (
  label: _scan,
  icon: const Icon(Icons.qr_code_scanner),
  content: find.byIcon(Icons.qr_code_scanner),
);
// Wider than either look's smallest button, so a shrink would show.
final _Kind _textKind = (label: _publish, icon: null, content: find.text(_publish));
final _kinds = {'an icon': _iconKind, 'text': _textKind};

PlatformBarAction _debounced(
  _Work work,
  _Kind kind, {
  AnimatedSwitcherTransitionBuilder? transition,
}) => .debounced(
  label: kind.label,
  icon: kind.icon,
  onPressed: work.run,
  transitionBuilder: transition,
);

Future<void> _pumpPublish(
  WidgetTester tester,
  _Work work, {
  AnimatedSwitcherTransitionBuilder? transition,
}) => _pump(
  tester,
  PlatformAppBar(primaryAction: _debounced(work, _textKind, transition: transition)),
);

// A fade the test can find, to read the animation the bar hands each side of the swap.
class const _Fade(final Widget child, final Animation<double> animation) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FadeTransition(opacity: animation, child: child);
}

final _transitions = <String, AnimatedSwitcherTransitionBuilder?>{
  'without a transition': null,
  'with a fade': _Fade.new,
};

Animation<double> _fadeOf(WidgetTester tester, Finder side) {
  final fade = find.ancestor(of: side, matching: find.byType(_Fade));
  check(because: 'the bar runs the transition it was given', fade.evaluate()).isNotEmpty();

  return tester.widget<_Fade>(fade.first).animation;
}

// Waits on the swap's own animation, so a scenario holds however long the bar makes it.
Future<void> _settle(WidgetTester tester, Finder content) async {
  final animation = _fadeOf(tester, content);
  while (animation.isAnimating) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

Finder get _spinner => switch (designLanguage) {
  .material => find.bySubtype<ProgressIndicator>(),
  .cupertino => find.byType(CupertinoActivityIndicator),
};

Color? _spinnerColour(WidgetTester tester) => switch (designLanguage) {
  .material => tester.widget<ProgressIndicator>(_spinner).color,
  .cupertino => tester.widget<CupertinoActivityIndicator>(_spinner).color,
};

// An icon's glyph is text too.
Color _colourOf(WidgetTester tester, Finder content) => tester
    .widget<RichText>(find.descendant(of: content, matching: find.byType(RichText)))
    .text
    .style!
    .color!;

// Hidden content stays in the tree, keeping the action's size, so only its painting tells.
bool _paintsText(WidgetTester tester, Finder finder) {
  final recordingCanvas = TestRecordingCanvas();
  tester.renderObject(finder).paint(TestRecordingPaintingContext(recordingCanvas), .zero);

  return recordingCanvas.invocations.any(
    (recorded) => recorded.invocation.memberName == #drawParagraph,
  );
}

// The tap runs in a zone of its own, as an app's error handler would, so the work's errors land there.
Future<List<Object>> _startSlowWork(
  WidgetTester tester,
  Finder content, {
  AnimatedSwitcherTransitionBuilder? transition,
}) async {
  final errors = <Object>[];
  await runZonedGuarded(() => tester.tap(_buttonOf(content)), (error, _) => errors.add(error));
  await pumpThrough(tester, kBarActionBusyDelay);

  check(because: 'the bar shows the work running', _spinner.evaluate()).length.equals(1);
  if (transition != null) await _settle(tester, content);

  return errors;
}

void main() {
  feature('PlatformAppBar', () {
    scenarioOutlineWidgets<({PlatformBarAction action, Finder content})>(
      "draws each action as the platform's own bar button",
      examples: {
        'an icon': (action: _shareAction, content: find.byIcon(Icons.share)),
        'text': (action: _editAction, content: find.text(_edit)),
      },
      outline: (tester, row) async {
        await _pump(
          tester,
          PlatformAppBar(
            title: const Text('Title'),
            materialAppBarData: MaterialAppBarData(actions: [_OwnBarButton(row.action)]),
            cupertinoNavigationBarData: CupertinoNavigationBarData(
              trailing: _OwnBarButton(row.action),
            ),
          ),
        );
        final own = _placed(tester, row.content);

        await _pump(tester, PlatformAppBar(title: const Text('Title'), actions: [row.action]));

        check(_placed(tester, row.content)).equals(own);
      },
    );

    scenarioWidgets('names an icon action for screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, const PlatformAppBar(actions: [_shareAction]));

      check(buttonsNamed(_share).evaluate()).isNotEmpty();
      semantics.dispose();
    });

    scenarioWidgets('puts the primary action last, at the trailing edge', (tester) async {
      await _pump(
        tester,
        const PlatformAppBar(actions: [_shareAction, _editAction], primaryAction: _saveAction),
      );

      check(tester.getRect(find.text(_save)).left)
          .isGreaterThan(tester.getRect(find.text(_edit)).right);
    });

    scenarioWidgets("sets the primary action's text semibold on iOS", (tester) async {
      await _pump(tester, const PlatformAppBar(actions: [_editAction], primaryAction: _saveAction));

      check(weightOf(labelStyle(tester, _save))).isGreaterThan(weightOf(labelStyle(tester, _edit)));
    }, variant: iosOnly);

    scenarioWidgets('draws the primary action like any other on Android', (tester) async {
      await _pump(tester, const PlatformAppBar(actions: [_editAction], primaryAction: _saveAction));

      check(labelStyle(tester, _save)).equals(labelStyle(tester, _edit));
    }, variant: androidOnly);

    // Only `.debounced` waits, since a push's or a share sheet's future runs until it closes.
    scenarioWidgets('takes every tap on a plain action, even while its work runs', (tester) async {
      final work = _Work();
      await _pump(
        tester,
        PlatformAppBar(
          primaryAction: PlatformBarAction(label: _save, onPressed: work.run),
        ),
      );
      final saveButton = _buttonOf(find.text(_save));

      await tester.tap(saveButton);
      await pumpThrough(tester, kBarActionBusyDelay);
      await tester.tap(saveButton);

      check(work.starts).equals(2);
    });

    scenarioOutlineWidgets<DesignLanguage>(
      "lets one platform's own widgets replace its side's actions",
      examples: {'Material': .material, 'Cupertino': .cupertino},
      outline: (tester, overridden) async {
        const custom = Text(_custom);
        await _pump(
          tester,
          PlatformAppBar(
            actions: [_shareAction],
            primaryAction: _saveAction,
            materialAppBarData: overridden == .material
                ? const MaterialAppBarData(actions: [custom])
                : const MaterialAppBarData(),
            cupertinoNavigationBarData: overridden == .cupertino
                ? const CupertinoNavigationBarData(trailing: custom)
                : const CupertinoNavigationBarData(),
          ),
        );
        final shown = {
          if (find.text(_custom).evaluate().isNotEmpty) _custom,
          if (find.byIcon(Icons.share).evaluate().isNotEmpty) _share,
          if (find.text(_save).evaluate().isNotEmpty) _save,
        };

        check(
          because: designLanguage.name,
          shown,
        ).deepEquals(designLanguage == overridden ? {_custom} : {_share, _save});
      },
    );

    // The own side's leading shows where it swaps a sheet's way out, below.
    scenarioWidgets('leaves out a leading widget given for the other platform', (tester) async {
      const custom = Text(_custom);
      await _pump(
        tester,
        PlatformAppBar(
          materialAppBarData: designLanguage == .cupertino
              ? const MaterialAppBarData(leading: custom)
              : const MaterialAppBarData(),
          cupertinoNavigationBarData: designLanguage == .material
              ? const CupertinoNavigationBarData(leading: custom)
              : const CupertinoNavigationBarData(),
        ),
      );

      check(find.text(_custom).evaluate()).isEmpty();
    });

    scenarioWidgets("goes back through the platform's own back button", (tester) async {
      await pumpInPlatformScaffold(tester, const Text(_first));
      Navigator.of(tester.element(find.text(_first))).push(
        PageRouteBuilder<void>(
          pageBuilder: (_, _, _) =>
              const PlatformScaffold(appBarData: PlatformAppBar(), body: SizedBox()),
        ),
      );
      await pumpTransition(tester);

      await tester.tap(switch (designLanguage) {
        .material => find.byType(BackButton),
        .cupertino => find.byType(CupertinoNavigationBarBackButton),
      });
      await pumpTransition(tester);

      check(find.text(_first).evaluate()).isNotEmpty();
    });

    scenarioWidgets("closes a sheet through the platform's own way out", (tester) async {
      await _openInSheet(tester, _sheetPage);

      await tester.tap(_sheetWayOut(tester));
      await pumpTransition(tester);

      check(find.byKey(_sheetBody).evaluate()).isEmpty();
    });

    // Material's CloseButton asks it by itself.
    scenarioWidgets("asks the sheet's PopScope before closing it", (tester) async {
      var attempts = 0;
      await _openInSheet(
        tester,
        PopScope<void>(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) attempts++;
          },
          child: _sheetPage,
        ),
      );

      await tester.tap(_sheetWayOut(tester));
      await pumpTransition(tester);

      check(find.byKey(_sheetBody).evaluate()).isNotEmpty();
      check(attempts).equals(1);
    }, variant: iosOnly);

    scenarioOutlineWidgets<PlatformAppBar>(
      "lets a sheet's bar swap or drop its way out",
      examples: {
        'swapped for its own leading': const PlatformAppBar(
          materialAppBarData: MaterialAppBarData(leading: Text(_custom)),
          cupertinoNavigationBarData: CupertinoNavigationBarData(leading: Text(_custom)),
        ),
        'dropped': const PlatformAppBar(automaticallyImplyLeading: false),
      },
      outline: (tester, bar) async {
        await _openInSheet(
          tester,
          PlatformScaffold(
            appBarData: bar,
            body: const SizedBox(key: _sheetBody),
          ),
        );
        check(find.byKey(_sheetBody).evaluate()).isNotEmpty();

        check(_sheetWayOut(tester).evaluate()).isEmpty();
      },
    );
  });

  feature('PlatformBarAction.debounced', () {
    scenarioOutlineWidgets<AnimatedSwitcherTransitionBuilder?>(
      'ignores taps while its work runs, then takes the next one',
      examples: _transitions,
      outline: (tester, transition) async {
        final work = _Work();
        await _pumpPublish(tester, work, transition: transition);
        final publishButton = _buttonOf(_textKind.content);

        await tester.tap(publishButton);
        await tester.pump();
        await tester.tap(publishButton);
        await pumpThrough(tester, kBarActionBusyDelay);
        await tester.tap(publishButton);
        check(because: 'while it runs', work.starts).equals(1);

        // Lets the fade in finish, so there's one to come back from.
        if (transition != null) await _settle(tester, _textKind.content);
        work.end();
        await tester.pump();
        await tester.tap(publishButton);

        check(because: 'once it is done', work.starts).equals(2);
      },
    );

    scenarioOutlineWidgets<AnimatedSwitcherTransitionBuilder?>(
      'shows nothing for work that ends before the delay',
      examples: _transitions,
      outline: (tester, transition) async {
        final work = _Work();
        await _pumpPublish(tester, work, transition: transition);
        final publishButton = _buttonOf(_textKind.content);
        void drawsAsUsual(String moment) {
          check(because: moment, _spinner.evaluate()).isEmpty();
          check(because: moment, _paintsText(tester, publishButton)).isTrue();
        }

        await tester.tap(publishButton);
        await tester.pump(kBarActionBusyDelay - const Duration(milliseconds: 1));
        drawsAsUsual('just before the delay');

        work.end();
        await pumpThrough(tester, kBarActionBusyDelay);

        drawsAsUsual('after it');
      },
    );

    scenarioOutlineWidgets<_Kind>(
      "shows the spinner in the action's place once its work outlasts the delay",
      examples: _kinds,
      outline: (tester, kind) async {
        await _pump(tester, PlatformAppBar(actions: [_debounced(_Work(), kind)]));
        final button = _buttonOf(kind.content);
        check(because: 'before the tap', _paintsText(tester, button)).isTrue();

        await _startSlowWork(tester, kind.content);

        check(because: 'it hides its own content', _paintsText(tester, button)).isFalse();
        check((tester.getCenter(_spinner) - tester.getCenter(kind.content)).distance)
            .isLessThan(0.5);
      },
    );

    scenarioOutlineWidgets<_Kind>(
      'runs the transition it is given between its content and the spinner, both ways',
      examples: _kinds,
      outline: (tester, kind) async {
        final work = _Work();
        await _pump(
          tester,
          PlatformAppBar(actions: [_debounced(work, kind, transition: _Fade.new)]),
        );
        ({AnimationStatus content, AnimationStatus spinner}) directions() => (
          content: _fadeOf(tester, kind.content).status,
          spinner: _fadeOf(tester, _spinner).status,
        );

        await _startSlowWork(tester, kind.content);
        check(
          because: 'on the way in',
          directions(),
        ).equals((content: .reverse, spinner: .forward));

        await _settle(tester, kind.content);
        work.end();
        await tester.pump();

        check(
          because: 'on the way out',
          directions(),
        ).equals((content: .forward, spinner: .reverse));
      },
    );

    scenarioOutlineWidgets<FakeAccessibilityFeatures>(
      'swaps at once when the device asks for less motion, even after the bar is built',
      examples: const {
        "Android's Remove animations": FakeAccessibilityFeatures(disableAnimations: true),
        "iOS's Reduce Motion": FakeAccessibilityFeatures(reduceMotion: true),
      },
      outline: (tester, lessMotion) async {
        await _pumpPublish(tester, _Work(), transition: _Fade.new);

        tester.platformDispatcher.accessibilityFeaturesTestValue = lessMotion;
        addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
        await _startSlowWork(tester, _textKind.content);

        check(_paintsText(tester, _buttonOf(_textKind.content))).isFalse();
      },
    );

    scenarioOutlineWidgets<AnimatedSwitcherTransitionBuilder?>(
      "keeps the action's width, so its neighbours stay put",
      examples: _transitions,
      outline: (tester, transition) async {
        await _pump(
          tester,
          PlatformAppBar(
            actions: const [_shareAction],
            primaryAction: _debounced(_Work(), _textKind, transition: transition),
          ),
        );
        final shareRect = tester.getRect(_buttonOf(find.byIcon(Icons.share)));

        await _startSlowWork(tester, _textKind.content, transition: transition);

        check(tester.getRect(_buttonOf(find.byIcon(Icons.share)))).equals(shareRect);
      },
    );

    scenarioOutlineWidgets<_Kind>(
      "draws the spinner in the action's own colour, not a disabled grey",
      examples: _kinds,
      outline: (tester, kind) async {
        await _pump(tester, PlatformAppBar(actions: [_debounced(_Work(), kind)]));
        final contentColour = _colourOf(tester, kind.content);

        await _startSlowWork(tester, kind.content);

        check(_spinnerColour(tester)?.toARGB32()).equals(contentColour.toARGB32());
      },
    );

    scenarioOutlineWidgets<_Kind>(
      'fades its content out in its own colour, not a disabled grey',
      examples: _kinds,
      outline: (tester, kind) async {
        await _pump(
          tester,
          PlatformAppBar(actions: [_debounced(_Work(), kind, transition: _Fade.new)]),
        );
        final contentColour = _colourOf(tester, kind.content);

        await _startSlowWork(tester, kind.content);
        final fadeOut = _fadeOf(tester, kind.content);
        while (fadeOut.value > 0.5) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        check(_colourOf(tester, kind.content).toARGB32()).equals(contentColour.toARGB32());
      },
    );

    // Only Material fades a label's colour between states, and only a text label's.
    scenarioWidgets('brings its label back in its own colour, not a disabled grey', (tester) async {
      final work = _Work();
      await _pumpPublish(tester, work);
      final labelColour = _colourOf(tester, _textKind.content);
      await _startSlowWork(tester, _textKind.content);
      // Lets the busy button settle into whatever colour it keeps while disabled.
      await pumpTransition(tester);

      work.end();
      await tester.pump();

      check(_colourOf(tester, _textKind.content).toARGB32()).equals(labelColour.toARGB32());
    }, variant: androidOnly);

    scenarioOutlineWidgets<AnimatedSwitcherTransitionBuilder?>(
      'tells screen readers it is disabled while its work runs, under its own name',
      examples: _transitions,
      outline: (tester, transition) async {
        final semantics = tester.ensureSemantics();
        await _pumpPublish(tester, _Work(), transition: transition);
        SemanticsData publishSemantics() =>
            buttonsNamed(_publish).evaluate().single.getSemanticsData();
        // An enabled Cupertino button reports no enabled state at all, so only "disabled" means anything.
        check(
          because: 'before the tap',
          publishSemantics().flagsCollection.isEnabled,
        ).not((isEnabled) => isEnabled.equals(.isFalse));

        await _startSlowWork(tester, _textKind.content, transition: transition);

        check(because: 'it keeps its name', buttonsNamed(_publish).evaluate()).length.equals(1);
        check(publishSemantics())
          ..has((data) => data.flagsCollection.isEnabled, 'enabled').equals(.isFalse)
          ..has((data) => data.hasAction(.tap), 'tap').isFalse();
        semantics.dispose();
      },
    );

    scenarioWidgets('keeps the busy look on its own action when one lands before it', (
      tester,
    ) async {
      final scanAction = _debounced(_Work(), _iconKind);
      await _pump(tester, PlatformAppBar(actions: [scanAction]));
      await _startSlowWork(tester, _iconKind.content);

      await _pump(tester, PlatformAppBar(actions: [_shareAction, scanAction]));

      check(find.descendant(of: _buttonOf(_iconKind.content), matching: _spinner).evaluate()).length
          .equals(1);
    });

    scenarioWidgets('takes taps again once its work fails', (tester) async {
      final work = _Work();
      await _pumpPublish(tester, work);
      await _startSlowWork(tester, _textKind.content);

      work.fail(StateError('offline'));
      await tester.pump();
      await tester.tap(_buttonOf(_textKind.content));

      check(work.starts).equals(2);
    });

    scenarioWidgets("lets its work's error through", (tester) async {
      final work = _Work();
      await _pumpPublish(tester, work);
      final errors = await _startSlowWork(tester, _textKind.content);
      final error = StateError('offline');

      work.fail(error);
      await tester.pump();

      check(errors).deepEquals([error]);
    });
  });
}

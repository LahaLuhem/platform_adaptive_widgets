// Size-harness app for the AOT-pruning regression guard. CI builds it for Android and iOS, and the size
// check (tool/check_size_regression.dart) holds each build to a budget for the look it doesn't draw.
//
// Goal: exercise every public dispatching entry point on the package so a future refactor that re-introduces
// deferred-dispatch (closures-as-args passed into a sub-helper) fails the size check where it broke.

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();

  @override
  // Not `MaterialApp`, whose Material would sit in an iOS build and hide what a widget brings there.
  Widget build(BuildContext context) => PlatformApp(home: PlatformScaffold(body: _Surfaces()));
}

class _Surfaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      // PlatformWidgetBase virtual dispatch.
      PlatformButton(onPressed: () {}, emphasis: .medium, child: const Text('platform button')),
      PlatformButton.iconOnly(
        onPressed: () {},
        emphasis: .low,
        icon: const Icon(Icons.share),
        label: 'share',
      ),
      const PlatformProgressBar(value: 0.3),
      PlatformMenuPicker<int>(
        items: Iterable<int>.generate(kCupertinoMenuPickerLargeItemCountThreshold + 1).toSet(),
        onSelected: (_) {},
      ),
      PlatformSingleSelectList<int>(
        options: const {1, 2},
        selected: 1,
        label: (option) => '$option',
        onChanged: (_) {},
        header: 'single select',
      ),
      PlatformMultiSelectList<int>(
        options: const {1, 2},
        selected: const {1},
        label: (option) => '$option',
        onChanged: (_) {},
        header: 'multi select',
      ),
      // The delete reaches the confirm's own top-level switch.
      PlatformActionsMenu(
        builder: (_, onPressed) =>
            PlatformButton(onPressed: onPressed, emphasis: .low, child: const Text('actions menu')),
        actions: {
          PlatformMenuAction.normal(label: 'share', onPressed: () {}),
          PlatformMenuAction.delete(label: 'delete', confirmMessage: 'sure?', onPressed: () {}),
        },
      ),

      // showPlatformSheet, top-level switch dispatch. The guard reaches the confirm's switch too.
      PlatformButton(
        onPressed: () => showPlatformSheet<void>(
          context: context,
          appBarBuilder: (_) => PlatformAppBar(
            title: const Text('title'),
            primaryAction: PlatformBarAction(label: 'save', onPressed: () {}),
          ),
          unsavedChanges: PlatformUnsavedChanges(
            hasChanges: () => true,
            message: 'discard?',
            discardLabel: 'discard',
          ),
          builder: (_) => const Text('sheet'),
        ),
        emphasis: .low,
        child: const Text('sheet'),
      ),

      // showPlatformRawDialog, top-level switch dispatch, with a builder per platform.
      PlatformButton(
        onPressed: () => showPlatformRawDialog<void>(
          context: context,
          // Not platform widgets: one in a closure stays in the other platform's build and hides a leak
          // of the same widgets.
          materialBuilder: (_) => const Text('m'),
          cupertinoBuilder: (_) => const Text('c'),
        ),
        emphasis: .low,
        child: const Text('raw dialog'),
      ),

      // showPlatformFullscreenDialog, top-level switch dispatch. Its bar builds both kinds of action.
      PlatformButton(
        onPressed: () => showPlatformFullscreenDialog<void>(
          context: context,
          appBarBuilder: (_) => PlatformAppBar(
            title: const Text('title'),
            actions: [
              PlatformBarAction(label: 'share', icon: const Icon(Icons.share), onPressed: () {}),
            ],
            primaryAction: PlatformBarAction(label: 'save', onPressed: () {}),
          ),
          builder: (_) => const Text('page'),
        ),
        emphasis: .low,
        child: const Text('fullscreen dialog'),
      ),

      // showPlatformConfirm, through the alert's top-level switch dispatch.
      PlatformButton(
        onPressed: () => showPlatformConfirm(
          context: context,
          title: 'title',
          message: 'message',
          confirmLabel: 'confirm',
          actionKind: .discard,
        ),
        emphasis: .low,
        child: const Text('confirm'),
      ),

      // showPlatformToast, single inline switch.
      PlatformButton(
        onPressed: () => showPlatformToast(
          context: context,
          message: 'hi',
          action: PlatformToastAction(label: 'undo', onPressed: () {}),
        ),
        emphasis: .low,
        child: const Text('toast'),
      ),

      // showPlatformDatePicker, top-level switch dispatch.
      PlatformButton(
        onPressed: () => showPlatformDatePicker(
          context: context,
          firstDate: Date.of(2020).getOrThrow(),
          lastDate: Date.of(2030).getOrThrow(),
          initialDate: Date.of(2024).getOrThrow(),
        ),
        emphasis: .low,
        child: const Text('date'),
      ),

      // showPlatformTimePicker, top-level switch dispatch.
      PlatformButton(
        onPressed: () => showPlatformTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 12, minute: 0),
        ),
        emphasis: .low,
        child: const Text('time'),
      ),

      // showPlatformChoices, top-level switch dispatch.
      PlatformButton(
        onPressed: () => showPlatformChoices(
          context: context,
          choices: const {
            PlatformChoice(value: 1, label: 'save', actionKind: .normal),
            PlatformChoice(value: 2, label: 'delete', actionKind: .delete),
          },
        ),
        emphasis: .low,
        child: const Text('choices'),
      ),

      // context.platformIcon, its own inline switch.
      Icon(context.platformIcon(material: Icons.home, cupertino: CupertinoIcons.home)),

      // designLanguage, switched on in app code.
      switch (designLanguage) {
        .material => const Text('material'),
        .cupertino => const Text('cupertino'),
      },
    ],
  );
}

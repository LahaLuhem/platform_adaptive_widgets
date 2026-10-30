// Size-harness app for the AOT-pruning regression guard. Built only for
// Android by CI, and tool/check_size_regression.dart checks the Cupertino
// symbols left in the resulting snapshot against a budget.
//
// Goal: exercise every public dispatching entry point on the package so a
// future refactor that re-introduces deferred-dispatch (closures-as-args
// passed into a sub-helper) fails the size check on the surface it broke.

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) => MaterialApp(home: Scaffold(body: _Surfaces()));
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
            TextButton(onPressed: onPressed, child: const Text('actions menu')),
        actions: {
          PlatformMenuAction.normal(label: 'share', onPressed: () {}),
          PlatformMenuAction.delete(label: 'delete', confirmMessage: 'sure?', onPressed: () {}),
        },
      ),

      // showPlatformSheet, top-level switch dispatch. The guard reaches the confirm's switch too.
      TextButton(
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
        child: const Text('sheet'),
      ),

      // showPlatformRawDialog, top-level switch dispatch, with a builder per platform.
      TextButton(
        onPressed: () => showPlatformRawDialog<void>(
          context: context,
          materialBuilder: (_) => const AlertDialog(content: Text('m')),
          // Not a Cupertino widget: one in a closure stays in the Android build and hides a leak of the
          // same widgets.
          cupertinoBuilder: (_) => const Text('c'),
        ),
        child: const Text('raw dialog'),
      ),

      // showPlatformFullscreenDialog, top-level switch dispatch. Its bar builds both kinds of action.
      TextButton(
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
        child: const Text('fullscreen dialog'),
      ),

      // showPlatformConfirm, through the alert's top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformConfirm(
          context: context,
          title: 'title',
          message: 'message',
          confirmLabel: 'confirm',
          actionKind: .discard,
        ),
        child: const Text('confirm'),
      ),

      // showPlatformToast, single inline switch.
      TextButton(
        onPressed: () => showPlatformToast(
          context: context,
          message: 'hi',
          action: PlatformToastAction(label: 'undo', onPressed: () {}),
        ),
        child: const Text('toast'),
      ),

      // showPlatformDatePicker, top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformDatePicker(
          context: context,
          firstDate: Date.of(2020).getOrThrow(),
          lastDate: Date.of(2030).getOrThrow(),
          initialDate: Date.of(2024).getOrThrow(),
        ),
        child: const Text('date'),
      ),

      // showPlatformTimePicker, top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 12, minute: 0),
        ),
        child: const Text('time'),
      ),

      // showPlatformChoices, top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformChoices(
          context: context,
          choices: const {
            PlatformChoice(value: 1, label: 'save', actionKind: .normal),
            PlatformChoice(value: 2, label: 'delete', actionKind: .delete),
          },
        ),
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

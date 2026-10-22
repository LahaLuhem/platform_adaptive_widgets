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
      PlatformButton(onPressed: () {}, child: const Text('platform button')),
      const PlatformProgressBar(value: 0.3),
      PlatformMenuPicker<int>(
        items: List.generate(
          kCupertinoMenuPickerLargeItemCountThreshold + 1,
          (index) => index,
          growable: false,
        ),
        onSelected: (_) {},
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

      // showPlatformDialog, top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformDialog<void>(
          context: context,
          materialBuilder: (_) => const AlertDialog(content: Text('m')),
          // Not a Cupertino widget: one in a closure stays in the Android build and hides a leak of the
          // same widgets.
          cupertinoBuilder: (_) => const Text('c'),
        ),
        child: const Text('dialog'),
      ),

      // showPlatformFullscreenDialog, top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformFullscreenDialog<void>(
          context: context,
          appBarData: const PlatformAppBar(title: Text('title')),
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

      // showPlatformModalBottomSheet, single inline switch.
      TextButton(
        onPressed: () => showPlatformModalBottomSheet<void>(
          context: context,
          builder: (_) => const Text('sheet'),
        ),
        child: const Text('sheet'),
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

// Size-harness app for the AOT-pruning regression guard. Built only for
// Android by CI; tool/check_size_regression.dart asserts no Cupertino
// symbols survive in the resulting snapshot.
//
// Goal: exercise every public dispatching entry point on the package so a
// future refactor that re-introduces deferred-dispatch (closures-as-args
// passed into a sub-helper) fails the size check on the surface it broke.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: Scaffold(body: _Surfaces()));
}

class _Surfaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      // PlatformWidgetBase virtual dispatch.
      PlatformButton(onPressed: () {}, child: const Text('platform button')),

      // showPlatformDialog — top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformDialog<void>(
          context: context,
          materialBuilder: (_) => const AlertDialog(content: Text('m')),
          cupertinoBuilder: (_) =>
              const CupertinoAlertDialog(content: Text('c')),
        ),
        child: const Text('dialog'),
      ),

      // showPlatformAlertDialog — top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformAlertDialog<void>(
          context: context,
          title: const Text('title'),
          content: const Text('content'),
        ),
        child: const Text('alert'),
      ),

      // showPlatformSimpleAlert — single inline switch.
      TextButton(
        onPressed: () => showPlatformSimpleAlert(
          context: context,
          message: 'hi',
          cupertinoOkLabel: 'ok',
        ),
        child: const Text('simple'),
      ),

      // showPlatformDatePicker — top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformDatePicker(
          context: context,
          firstDate: const Date(year: 2020),
          lastDate: const Date(year: 2030),
          initialDate: const Date(year: 2024),
        ),
        child: const Text('date'),
      ),

      // showPlatformTimePicker — top-level switch dispatch.
      TextButton(
        onPressed: () => showPlatformTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 12, minute: 0),
        ),
        child: const Text('time'),
      ),

      // showPlatformModalBottomSheet — single inline switch.
      TextButton(
        onPressed: () => showPlatformModalBottomSheet<void>(
          context: context,
          builder: (_) => const Text('sheet'),
        ),
        child: const Text('sheet'),
      ),

      // context.platformIcon — extension that uses platformValue internally
      // (cheap-value usage; safe because IconData doesn't drag platform code).
      Icon(
        context.platformIcon(
          material: Icons.home,
          cupertino: CupertinoIcons.home,
        ),
      ),

      // isAndroid / isIOS — const-folded getters.
      if (isAndroid) const Text('android') else const Text('ios'),
    ],
  );
}

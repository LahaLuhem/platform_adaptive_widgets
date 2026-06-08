import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/widgets/demo_card.dart';
import '/features/catalog/widgets/property_editor/bool_knob.dart';
import '/features/catalog/widgets/property_editor/property_editor.dart';
import '/features/catalog/widgets/property_editor/string_knob.dart';
import 'dialogs_demo_view_model.dart';

/// The Dialogs & pickers section of the Catalog accordion. Dialogs are
/// imperative, so the playgrounds are configure-then-trigger: knobs set the
/// args, the button fires the dialog.
class DialogsDemoView extends StatelessWidget {
  const DialogsDemoView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: DialogsDemoViewModel(),
    viewBuilder: (context, viewModel) => Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        DemoCard(
          title: 'Dialog',
          description: 'A centered modal — showDialog on Android, showCupertinoDialog on iOS.',
          child: PlatformButton(
            onPressed: viewModel.onShowDialogPressed,
            child: const Text('Show dialog'),
          ),
        ),
        DemoCard(
          title: 'Raw dialog',
          description: 'No surface wrap — you supply the surface (or none).',
          child: PropertyEditor(
            preview: PlatformButton(
              onPressed: viewModel.onShowRawDialogPressed,
              child: const Text('Show raw dialog'),
            ),
            knobs: [
              BoolKnob(
                label: 'barrierDismissible',
                value: viewModel.shouldDismissRawDialogOnBarrierTap,
                onChanged: (value) => viewModel.onBarrierDismissibleToggled(value: value),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Alert dialog',
          description: 'Title, message, and adaptive action buttons.',
          child: PropertyEditor(
            preview: PlatformButton(
              onPressed: viewModel.onShowAlertDialogPressed,
              child: const Text('Show alert'),
            ),
            knobs: [
              StringKnob(
                label: 'title',
                value: viewModel.alertTitle,
                onChanged: viewModel.onAlertTitleChanged,
              ),
              StringKnob(
                label: 'message',
                value: viewModel.alertMessage,
                onChanged: viewModel.onAlertMessageChanged,
              ),
              BoolKnob(
                label: 'destructive action',
                value: viewModel.shouldIncludeDestructiveAction,
                onChanged: (value) => viewModel.onDestructiveActionToggled(value: value),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Toast & acknowledge',
          description: 'A transient toast, then a blocking acknowledgement.',
          child: PlatformButton(
            onPressed: viewModel.onShowToastAndAcknowledgePressed,
            child: const Text('Show toast → acknowledge'),
          ),
        ),
        DemoCard(
          title: 'Modal bottom sheet',
          description: 'Slides up from the bottom of the screen.',
          child: PlatformButton(
            onPressed: viewModel.onShowBottomSheetPressed,
            child: const Text('Show bottom sheet'),
          ),
        ),
        DemoCard(
          title: 'Raw bottom sheet',
          description: 'No surface wrap — content floats on iOS; Android keeps its native sheet.',
          child: PlatformButton(
            onPressed: viewModel.onShowRawBottomSheetPressed,
            child: const Text('Show raw bottom sheet'),
          ),
        ),
        DemoCard(
          title: 'Date picker',
          description: 'A calendar dialog on Android, a wheel on iOS.',
          child: PlatformButton(
            onPressed: viewModel.onShowDatePickerPressed,
            child: Text(viewModel.selectedDate?.toString() ?? 'Pick a date'),
          ),
        ),
        DemoCard(
          title: 'Time picker',
          description: 'A clock dialog on Android, a wheel on iOS.',
          child: PlatformButton(
            onPressed: viewModel.onShowTimePickerPressed,
            child: Text(viewModel.selectedTime?.toString() ?? 'Pick a time'),
          ),
        ),
      ],
    ),
  );
}

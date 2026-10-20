import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/alert_actions.dart';
import '/features/catalog/widgets/demo_card.dart';
import '/features/catalog/widgets/property_editor/bool_knob.dart';
import '/features/catalog/widgets/property_editor/property_editor.dart';
import '/features/catalog/widgets/property_editor/segment_knob.dart';
import '/features/catalog/widgets/property_editor/string_knob.dart';
import 'dialogs_demo_view_model.dart';

/// The Dialogs & pickers section of the Catalog accordion. Dialogs open from a function call, not as a
/// widget, so each playground is configure-then-trigger: knobs set the args, the button opens the dialog.
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
          description:
              'A centered modal, showDialog on Material, showCupertinoDialog on Cupertino. '
              'Raw leaves out the card around the content.',
          child: PropertyEditor(
            preview: PlatformButton(
              onPressed: viewModel.onShowDialogPressed,
              child: const Text('Show dialog'),
            ),
            knobs: [
              BoolKnob(
                label: 'raw',
                value: viewModel.isDialogRaw,
                onChanged: (value) => viewModel.onDialogRawToggled(value: value),
              ),
              BoolKnob(
                label: 'barrierDismissible',
                value: viewModel.shouldDismissDialogOnBarrierTap,
                onChanged: (value) => viewModel.onBarrierDismissibleToggled(value: value),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Full-screen dialog',
          description:
              'A full-screen dialog on Material, a page that slides up on Cupertino. Its bar closes it.',
          child: PlatformButton(
            onPressed: viewModel.onShowFullscreenDialogPressed,
            child: Text(
              viewModel.savedEvent == null ? 'New event' : 'Saved: ${viewModel.savedEvent}',
            ),
          ),
        ),
        DemoCard(
          title: 'Alert dialog',
          description: 'Title, message and actions, from a lone OK up to a destructive choice.',
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
              SegmentKnob<AlertActions>(
                label: 'actions',
                value: viewModel.alertActions,
                values: AlertActions.values,
                onChanged: viewModel.onAlertActionsChanged,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Toast',
          description:
              'A snackbar on Material, a banner on Cupertino. With an action, it waits to be tapped.',
          child: PropertyEditor(
            preview: PlatformButton(
              onPressed: viewModel.onShowToastPressed,
              child: Text(viewModel.isUndone ? 'Undone' : 'Show toast'),
            ),
            knobs: [
              BoolKnob(
                label: 'action',
                value: viewModel.shouldOfferUndo,
                onChanged: (value) => viewModel.onUndoToggled(value: value),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Modal bottom sheet',
          description:
              'Slides up from the bottom of the screen. Raw leaves out the surface on Cupertino, '
              'Material keeps its native sheet.',
          child: PropertyEditor(
            preview: PlatformButton(
              onPressed: viewModel.onShowBottomSheetPressed,
              child: const Text('Show bottom sheet'),
            ),
            knobs: [
              BoolKnob(
                label: 'raw',
                value: viewModel.isSheetRaw,
                onChanged: (value) => viewModel.onSheetRawToggled(value: value),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Date & time pickers',
          description: 'A calendar or clock dialog on Material, wheels on Cupertino.',
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: PlatformButton(
                  onPressed: viewModel.onShowDatePickerPressed,
                  child: Text(viewModel.selectedDate?.toString() ?? 'Pick a date'),
                ),
              ),
              Expanded(
                child: PlatformButton(
                  onPressed: viewModel.onShowTimePickerPressed,
                  child: Text(viewModel.selectedTime?.toString() ?? 'Pick a time'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

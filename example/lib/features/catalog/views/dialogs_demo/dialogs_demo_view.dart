import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
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
  // Reaches what the dialogs hold, not the buttons that open them, so they still open.
  final bool shouldEnable;

  const DialogsDemoView({required this.shouldEnable, super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: DialogsDemoViewModel(),
    viewBuilder: (context, viewModel) => Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        DemoCard(
          title: 'Sheet',
          description:
              "M3's bottom sheet on Material, a sheet on Cupertino. Type a name, then close it without "
              'saving, and it asks first.',
          child: PlatformButton(
            onPressed: () => viewModel.onShowSheetPressed(shouldEnable: shouldEnable),
            emphasis: .medium,
            child: const Text('New list'),
          ),
        ),
        DemoCard(
          title: 'Raw dialog',
          description:
              'A centered modal with no card around the content, showDialog on Material, '
              'showCupertinoDialog on Cupertino.',
          child: PropertyEditor(
            preview: PlatformButton(
              onPressed: viewModel.onShowRawDialogPressed,
              emphasis: .medium,
              child: const Text('Show dialog'),
            ),
            knobs: [
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
            onPressed: () => viewModel.onShowFullscreenDialogPressed(shouldEnable: shouldEnable),
            emphasis: .medium,
            child: const Text('New event'),
          ),
        ),
        DemoCard(
          title: 'Alert dialog',
          description:
              'OK alone, or Cancel and a named action whose kind sets its look on Cupertino.',
          child: PropertyEditor(
            preview: PlatformButton(
              onPressed: viewModel.onShowAlertDialogPressed,
              emphasis: .medium,
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
              if (viewModel.alertActions == .confirm)
                StringKnob(
                  label: 'confirmLabel',
                  value: viewModel.confirmLabel,
                  onChanged: viewModel.onConfirmLabelChanged,
                ),
            ],
            cupertinoKnobs: [
              if (viewModel.alertActions == .confirm)
                SegmentKnob<PlatformActionKind>(
                  label: 'actionKind',
                  value: viewModel.confirmActionKind,
                  values: PlatformActionKind.values,
                  onChanged: viewModel.onConfirmActionKindChanged,
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
              emphasis: .medium,
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
          title: 'Raw bottom sheet',
          description:
              'Slides up from the bottom of the screen. Material keeps its own sheet, while Cupertino '
              'gets no surface around the content.',
          child: PlatformButton(
            onPressed: viewModel.onShowRawBottomSheetPressed,
            emphasis: .medium,
            child: const Text('Show bottom sheet'),
          ),
        ),
        DemoCard(
          title: 'Choices',
          description:
              'An action sheet on Cupertino, a sheet of rows on Material. Cupertino puts the delete on '
              'top, in red.',
          child: PlatformButton(
            onPressed: viewModel.onShowChoicesPressed,
            emphasis: .medium,
            child: Text(
              viewModel.draftOutcome == null ? 'Unsent draft' : 'Draft ${viewModel.draftOutcome}',
            ),
          ),
        ),
        DemoCard(
          title: 'Actions menu',
          description:
              'A pull-down menu on Cupertino, an M3 menu on Material. Delete asks first, and is red on '
              'Cupertino.',
          child: PlatformActionsMenu(
            builder: (_, onPressed) => PlatformButton(
              onPressed: onPressed,
              emphasis: .medium,
              child: const Text('Grocery list'),
            ),
            actions: {
              PlatformMenuAction.normal(
                label: 'Share List',
                iconData: context.platformIcon(
                  material: Icons.share_outlined,
                  cupertino: CupertinoIcons.square_arrow_up,
                ),
                onPressed: viewModel.onShareListPressed,
                isEnabled: shouldEnable,
              ),
              PlatformMenuAction.normal(
                label: 'Print',
                iconData: context.platformIcon(
                  material: Icons.print_outlined,
                  cupertino: CupertinoIcons.printer,
                ),
                onPressed: viewModel.onPrintPressed,
                isEnabled: shouldEnable,
              ),
              PlatformMenuAction.delete(
                label: 'Delete List',
                confirmMessage: 'This deletes the list and its reminders.',
                iconData: context.platformIcon(
                  material: Icons.delete_outline,
                  cupertino: CupertinoIcons.trash,
                ),
                onPressed: viewModel.onDeleteListPressed,
                isEnabled: shouldEnable,
              ),
            },
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
                  emphasis: .medium,
                  child: Text(viewModel.selectedDate?.toString() ?? 'Pick a date'),
                ),
              ),
              Expanded(
                child: PlatformButton(
                  onPressed: viewModel.onShowTimePickerPressed,
                  emphasis: .medium,
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

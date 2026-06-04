import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/widgets/demo_card.dart';
import 'dialogs_demo_view_model.dart';

/// The Dialogs & pickers section of the Catalog accordion.
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
          title: 'Alert dialog',
          description: 'Title, message, and adaptive action buttons.',
          child: PlatformButton(
            onPressed: viewModel.onShowAlertDialogPressed,
            child: const Text('Show alert'),
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
          title: 'Date picker',
          description: 'A calendar dialog on Android, a wheel on iOS.',
          child: PlatformButton(
            onPressed: viewModel.onShowDatePickerPressed,
            child: ValueListenableBuilder(
              valueListenable: viewModel.selectedDateListenable,
              builder: (_, selectedDate, _) => Text(selectedDate?.toString() ?? 'Pick a date'),
            ),
          ),
        ),
        DemoCard(
          title: 'Time picker',
          description: 'A clock dialog on Android, a wheel on iOS.',
          child: PlatformButton(
            onPressed: viewModel.onShowTimePickerPressed,
            child: ValueListenableBuilder(
              valueListenable: viewModel.selectedTimeListenable,
              builder: (_, selectedTime, _) => Text(selectedTime?.toString() ?? 'Pick a time'),
            ),
          ),
        ),
      ],
    ),
  );
}

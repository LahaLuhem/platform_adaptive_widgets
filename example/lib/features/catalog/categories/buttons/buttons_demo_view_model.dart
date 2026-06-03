import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// The buttons are the showcase; this just proves they fire by toasting the
/// pressed variant's name.
final class ButtonsDemoViewModel extends ViewModel {
  Future<void> onButtonPressed(String label) =>
      showPlatformToast(context: context, message: '$label button pressed');
}

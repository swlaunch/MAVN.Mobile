import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog.dart';

class EnableLocationDialog extends CustomDialog {
  EnableLocationDialog(LocalizedStrings localizedStrings)
      : super(
          title: localizedStrings.locationDialogTitle,
          content: localizedStrings.locationDialogDescription,
          positiveButtonText: localizedStrings.warningDialogGoToSettings,
          negativeButtonText: localizedStrings.warningDialogNoButton,
        );
}

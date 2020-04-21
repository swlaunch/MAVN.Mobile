import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog.dart';
import 'package:pedantic/pedantic.dart';

class LogOutConfirmationDialog extends CustomDialog {
  LogOutConfirmationDialog(LocalizedStrings localizedStrings)
      : super(
          title: localizedStrings.accountPageLogOutConfirmTitle,
          content: localizedStrings.accountPageLogOutConfirmContent,
          positiveButtonText: localizedStrings.warningDialogYesButton,
          negativeButtonText: localizedStrings.warningDialogNoButton,
        );

  @override
  Future<void> onPositiveButtonTap(BuildContext context, Router router,
      ValueNotifier<bool> isLoading) async {
    isLoading.value = true;
    await useLogOutUseCase(context: context).execute();

    unawaited(router.navigateToLoginPage());
  }
}

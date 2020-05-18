import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_base_action.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog.dart';

class ScannedInfoDialog extends CustomDialog {
  ScannedInfoDialog({@required this.action})
      : super(
          title: LocalizedStrings.scannedInfoDialogTitle,
          content: action.dialogMessage,
          positiveButtonText: action.dialogPositiveButtonTitle,
          negativeButtonText: LocalizedStrings.scannedInfoDialogNegativeButton,
        );

  final QrBaseAction action;

  @override
  Future<void> onPositiveButtonTap(BuildContext context, Router router,
      ValueNotifier<bool> isLoading) async {
    await action.goToAction();
  }
}

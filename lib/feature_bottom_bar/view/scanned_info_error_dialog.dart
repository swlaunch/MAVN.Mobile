import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_base_action.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog.dart';

class ScannedInfoErrorDialog extends CustomDialog {
  ScannedInfoErrorDialog(
    LocalizedStrings localizedStrings, {
    @required this.action,
  }) : super(
          title: localizedStrings.error,
          content: action.errorMessage.from(localizedStrings),
          negativeButtonText: localizedStrings.cancelButton,
        );

  final QrBaseAction action;
}

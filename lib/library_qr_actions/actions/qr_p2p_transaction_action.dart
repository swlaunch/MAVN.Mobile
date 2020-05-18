import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_base_action.dart';

class QrGoToP2PTransactionAction extends QrBaseAction {
  QrGoToP2PTransactionAction({
    @required this.router,
    @required this.tokenSymbol,
  });

  static const emailRegex =
      r'^((?!\.)[\w-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$'; //Example: https://regex101.com/r/SOgUIV/1

  final Router router;
  final String tokenSymbol;

  @override
  Future<void> goToAction() {
    router
      ..popToRoot()
      ..switchToWalletTab()
      ..pushTransactionFormPage(emailAddress: qrCodeContent);
  }

  @override
  Future<bool> match(String qrCodeContent) {
    final regExp = RegExp(emailRegex, caseSensitive: false, multiLine: false);
    final isEmail = regExp.hasMatch(qrCodeContent);
    if (isEmail) {
      this.qrCodeContent = qrCodeContent;
    }

    return Future.value(isEmail);
  }

  @override
  LocalizedStringBuilder get dialogPositiveButtonTitle =>
      LazyLocalizedStrings.scannedInfoDialogEmailPositiveButton(tokenSymbol);

  @override
  LocalizedStringBuilder get dialogMessage =>
      LocalizedStringBuilder.custom(qrCodeContent);
}

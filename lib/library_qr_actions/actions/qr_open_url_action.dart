import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_base_action.dart';

class QrOpenUrlAction extends QrBaseAction {
  QrOpenUrlAction({this.externalRouter});

  static const urlRegex =
      r'((?:https?\:\/\/|www\.)(?:[-a-z0-9]+\.)*[-a-z0-9]+.*)'; //Example: https://regex101.com/r/rP0zM0/1

  final ExternalRouter externalRouter;

  @override
  Future<void> goToAction() async {
    await externalRouter.launchUrl(qrCodeContent);
  }

  @override
  Future<bool> match(String qrCodeContent) async {
    final regExp = RegExp(urlRegex, caseSensitive: false, multiLine: false);
    final isLink = regExp.hasMatch(qrCodeContent) &&
        await externalRouter.canLaunchUrl(qrCodeContent);
    if (isLink) {
      this.qrCodeContent = qrCodeContent;
    }

    return isLink;
  }

  @override
  LocalizedStringBuilder get dialogPositiveButtonTitle =>
      LazyLocalizedStrings.scannedInfoDialogPositiveButton;

  @override
  LocalizedStringBuilder get dialogMessage =>
      LocalizedStringBuilder.custom(qrCodeContent);
}

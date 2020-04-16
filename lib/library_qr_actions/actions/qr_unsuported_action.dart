import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_base_action.dart';

class QrUnsupportedAction extends QrBaseAction {
  ///Keep this as the last action in the list !!!
  ///Because this is the default action it always matches => true
  QrUnsupportedAction();

  @override
  Future<void> goToAction() {}

  @override
  Future<bool> match(String pattern) => Future.value(true);

  @override
  String get dialogPositiveButtonTitle => null;

  @override
  String get qrCodeContent => null;

  @override
  String get dialogMessage => LocalizedStrings.scannedInfoDialogErrorMessage;
}

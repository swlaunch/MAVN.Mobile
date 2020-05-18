import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';

abstract class QrBaseAction {
  LocalizedStringBuilder get dialogPositiveButtonTitle;

  LocalizedStringBuilder get dialogMessage;

  String qrCodeContent;

  Future<void> goToAction();

  Future<bool> match(String pattern);
}

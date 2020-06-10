import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';

abstract class QrBaseAction {
  LocalizedStringBuilder get dialogPositiveButtonTitle;

  LocalizedStringBuilder get dialogMessage;

  LocalizedStringBuilder get errorButtonTitle => LocalizedStringBuilder.empty();

  LocalizedStringBuilder get errorMessage => LocalizedStringBuilder.empty();

  String qrCodeContent;

  Future<void> goToAction();

  Future<bool> match(String pattern);

  ///add default value for actions
  ///that do not require validation
  Future<bool> validate(String content) => Future.value(true);
}

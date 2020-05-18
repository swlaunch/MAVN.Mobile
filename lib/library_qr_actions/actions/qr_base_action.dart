abstract class QrBaseAction {
  String get dialogPositiveButtonTitle;

  String get dialogMessage;

  String qrCodeContent;

  Future<void> goToAction();

  Future<bool> match(String pattern);
}

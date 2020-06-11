import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/actions/voucher_qr_content.dart';
import 'package:lykke_mobile_mavn/library_extensions/tuple_extensions.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_base_action.dart';

class QrInvalidateVoucherAction extends QrBaseAction {
  QrInvalidateVoucherAction({
    @required this.router,
    @required this.customerBloc,
  });

  static const voucherRegEx = r'^PId=[a-z\d-]{36}&SC=[A-Z\d]{13}$';

  final Router router;

  final CustomerBloc customerBloc;

  @override
  Future<void> goToAction() {
    final voucherQrContent = VoucherQrContent(qrCodeContent).decode();
    router
      ..popToRoot()
      ..switchToWalletTab()
      ..pushSmeInvalidateVoucherPage(
          voucherShortCode:
              voucherQrContent.getValueByKey(VoucherQrContent.shortCodeKey));
  }

  @override
  Future<bool> match(String qrCodeContent) {
    final regExp = RegExp(voucherRegEx, caseSensitive: false, multiLine: false);
    final isVoucher = regExp.hasMatch(qrCodeContent);
    if (isVoucher) {
      this.qrCodeContent = qrCodeContent;
    }

    return Future.value(isVoucher);
  }

  @override
  LocalizedStringBuilder get dialogPositiveButtonTitle =>
      LazyLocalizedStrings.scannedInfoDialogVoucherPositiveButton;

  @override
  LocalizedStringBuilder get dialogMessage =>
      LocalizedStringBuilder.custom(qrCodeContent);

  @override
  LocalizedStringBuilder get errorButtonTitle =>
      LazyLocalizedStrings.cancelButton;

  @override
  LocalizedStringBuilder get errorMessage =>
      LazyLocalizedStrings.scannedInfoDialogVoucherError;

  @override
  Future<bool> validate(String content) {
    final voucherQrContent = VoucherQrContent(content).decode();

    return Future.value(customerBloc.currentState is CustomerLoadedState &&
        (customerBloc.currentState as CustomerLoadedState)
                .customer
                .linkedPartnerId ==
            voucherQrContent.getValueByKey(VoucherQrContent.partnerIdKey));
  }
}

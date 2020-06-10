import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/sme/request_model/invalidate_voucher_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/sme/request_model/sme_linking_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/sme/sme_api.dart';

class SmeRepository {
  SmeRepository(this._smeApi);

  final SmeApi _smeApi;

  Future<void> linkSmeAccount({
    @required String partnerCode,
    @required String linkingCode,
  }) =>
      _smeApi.linkSmeAccount(SmeLinkingRequestModel(
        partnerCode: partnerCode,
        linkingCode: linkingCode,
      ));

  Future<void> invalidateVoucher({
    @required String voucherShortCode,
    @required String validationCode,
  }) =>
      _smeApi.invalidateVoucher(InvalidateVoucherRequestModel(
        voucherShortCode: voucherShortCode,
        voucherValidationCode: validationCode,
      ));
}

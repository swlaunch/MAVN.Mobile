import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/request_model/cancel_voucher_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/voucher_purchase_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/request_model/voucher_transfer_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_details_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/voucher_api.dart';

class VoucherRepository {
  VoucherRepository(this._voucherApi);

  final VoucherApi _voucherApi;

  static const itemsPerPage = 5;

  Future<VoucherListResponseModel> getVouchers({int currentPage}) =>
      _voucherApi.getVouchers(itemsPerPage, currentPage);

  Future<VoucherDetailsResponseModel> getVoucherDetails({
    @required String shortCode,
  }) =>
      _voucherApi.getVoucherDetailsByShortCode(shortCode);

  Future<VoucherPurchaseResponseModel> getPaymentUrl({
    @required String shortCode,
  }) =>
      _voucherApi.getPaymentUrl(shortCode);

  Future<void> cancelVoucher({
    @required String shortCode,
  }) =>
      _voucherApi
          .cancelVoucher(CancelVoucherRequestModel(shortCode: shortCode));

  Future<void> transferVoucher({
    @required String receiverEmail,
    @required String shortCode,
  }) =>
      _voucherApi.transferVoucher(VoucherTransferRequestModel(
        receiverEmail: receiverEmail,
        voucherShortCode: shortCode,
      ));
}

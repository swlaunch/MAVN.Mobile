import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/voucher_api.dart';

class VoucherRepository {
  VoucherRepository(this._voucherApi);

  final VoucherApi _voucherApi;

  static const itemsPerPage = 30;

  Future<VoucherListResponseModel> getVouchers({int currentPage}) =>
      _voucherApi.getVouchers(itemsPerPage, currentPage);

  Future<VoucherResponseModel> getVoucherDetails({
    @required String id,
  }) =>
      _voucherApi.getVoucherDetailsById(id);
}

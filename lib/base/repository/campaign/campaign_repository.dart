import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/campaign_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/request_model/voucher_purchase_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/campaign_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/voucher_purchase_response_model.dart';

class CampaignRepository {
  CampaignRepository(this._campaignApi);

  final CampaignApi _campaignApi;

  static const itemsPerPage = 30;

  Future<CampaignListResponseModel> getCampaigns({int currentPage}) =>
      _campaignApi.getVouchers(itemsPerPage, currentPage);

  Future<CampaignResponseModel> getCampaignDetails({
    @required String id,
  }) =>
      _campaignApi.getVoucherDetailsById(id);

  Future<VoucherPurchaseResponseModel> purchaseVoucher({
    @required String id,
  }) =>
      _campaignApi.purchaseVoucher(VoucherPurchaseRequestModel(campaignId: id));
}

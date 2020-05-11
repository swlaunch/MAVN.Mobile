import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/spend/spend_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_purchase_response_model.dart';

class SpendRepository {
  SpendRepository(this._spendApi);

  final SpendApi _spendApi;

  Future<SpendRuleListResponseModel> getSpendRules({
    int currentPage = 1,
    int pageSize = 3,
  }) =>
      _spendApi.getSpendRules(
        currentPage: currentPage,
        pageSize: pageSize,
      );

  Future<SpendRule> getSpendRuleDetail({@required String spendRuleId}) =>
      _spendApi.getSpendRuleById(spendRuleId: spendRuleId);

  Future<VoucherPurchaseResponseModel> purchaseVoucher({
    @required String spendRuleId,
  }) =>
      _spendApi.purchaseVoucher(spendRuleId: spendRuleId);
}

import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/earn_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_staking_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';

class EarnRepository {
  EarnRepository(this._earnApi);

  final EarnApi _earnApi;

  Future<EarnRuleListResponseModel> getEarnRules({
    int currentPage = 1,
    int pageSize = 30,
  }) =>
      _earnApi.getEarnRules(currentPage: currentPage, pageSize: pageSize);

  Future<ExtendedEarnRule> getExtendedEarnRule({@required String earnRuleId}) =>
      _earnApi.getEarnRuleById(earnRuleId: earnRuleId);

  Future<EarnRuleStakingListResponseModel> getEarnRuleStakings(
          {@required String earnRuleId}) =>
      _earnApi.getEarnRuleStakings(earnRuleId: earnRuleId);
}

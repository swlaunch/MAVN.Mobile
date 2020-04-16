import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/partner_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_condition_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';

class ExtendedEarnRuleCondition extends EarnRuleCondition {
  ExtendedEarnRuleCondition({
    @required this.partners,
    @required this.customerCompletionCount,
    @required String id,
    @required EarnRuleConditionType type,
    @required OfferVertical vertical,
    @required String displayName,
    @required TokenCurrency immediateReward,
    @required int completionCount,
    @required bool hasStaking,
    @required TokenCurrency stakeAmount,
    @required int stakingPeriod,
    @required int stakeWarningPeriod,
    @required double stakingRule,
    @required double burningRule,
    @required RewardType rewardType,
    @required TokenCurrency amountInTokens,
    @required double amountInCurrency,
    @required bool usePartnerCurrencyRate,
  }) : super(
          id: id,
          type: type,
          vertical: vertical,
          displayName: displayName,
          immediateReward: immediateReward,
          completionCount: completionCount,
          hasStaking: hasStaking,
          stakeAmount: stakeAmount,
          stakingPeriod: stakingPeriod,
          stakeWarningPeriod: stakeWarningPeriod,
          stakingRule: stakingRule,
          burningRule: burningRule,
          rewardType: rewardType,
          amountInTokens: amountInTokens,
          amountInCurrency: amountInCurrency,
          usePartnerCurrencyRate: usePartnerCurrencyRate,
        );

  ExtendedEarnRuleCondition.fromJson(Map<String, dynamic> json)
      : partners = Partner.toListOfPartners(json['Partners']),
        customerCompletionCount = json['CustomerCompletionCount'],
        super.fromJson(json);

  static List<ExtendedEarnRuleCondition> toListFromJson(List list) =>
      list == null
          ? []
          : list
              .map((condition) => ExtendedEarnRuleCondition.fromJson(condition))
              .toList();

  final List<Partner> partners;
  final int customerCompletionCount;
}

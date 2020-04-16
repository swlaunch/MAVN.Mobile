import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

class EarnRuleCondition {
  EarnRuleCondition({
    @required this.id,
    @required this.type,
    @required this.vertical,
    @required this.displayName,
    @required this.immediateReward,
    @required this.completionCount,
    @required this.hasStaking,
    @required this.stakeAmount,
    @required this.stakingPeriod,
    @required this.stakeWarningPeriod,
    @required this.stakingRule,
    @required this.burningRule,
    @required this.rewardType,
    @required this.amountInTokens,
    @required this.amountInCurrency,
    @required this.usePartnerCurrencyRate,
  });

  EarnRuleCondition.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = EnumMapper.mapFromString(json['Type'].replaceAll('-', ''),
            enumValues: EarnRuleConditionType.values, defaultValue: null),
        vertical = EnumMapper.mapFromString(
          json['Vertical'],
          enumValues: OfferVertical.values,
          defaultValue: null,
        ),
        displayName = json['DisplayName'],
        immediateReward = TokenCurrency(value: json['ImmediateReward']),
        completionCount = json['CompletionCount'],
        hasStaking = json['HasStaking'],
        stakeAmount = TokenCurrency(value: json['StakeAmount']),
        stakingPeriod = json['StakingPeriod'],
        stakeWarningPeriod = json['StakeWarningPeriod'],
        stakingRule = json['StakingRule'],
        burningRule = json['BurningRule'],
        rewardType = EnumMapper.mapFromString(json['RewardType'],
            enumValues: RewardType.values, defaultValue: null),
        amountInTokens = TokenCurrency(value: json['AmountInTokens']),
        amountInCurrency = json['AmountInCurrency'],
        usePartnerCurrencyRate = json['UsePartnerCurrencyRate'];

  final String id;
  final EarnRuleConditionType type;
  final OfferVertical vertical;
  final String displayName;
  final TokenCurrency immediateReward;
  final int completionCount;
  final bool hasStaking;
  final TokenCurrency stakeAmount;
  final int stakingPeriod;
  final int stakeWarningPeriod;
  final double stakingRule;
  final double burningRule;
  final RewardType rewardType;
  final TokenCurrency amountInTokens;
  final double amountInCurrency;
  final bool usePartnerCurrencyRate;

  static List<EarnRuleCondition> toListFromJson(List list) => list == null
      ? []
      : list.map((condition) => EarnRuleCondition.fromJson(condition)).toList();
}

enum EarnRuleConditionType {
  signUp,
  estateLeadReferral,
  propertyPurchaseCommissionOne,
  propertyPurchaseCommissionTwo,
  hotelStayReferral,
  hotelStay,
  friendReferral,
}

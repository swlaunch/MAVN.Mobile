import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';

class EarnRuleStakingResponseModel {
  EarnRuleStakingResponseModel({
    @required this.referralId,
    @required this.referralName,
    @required this.stakeAmount,
    @required this.totalReward,
    @required this.stakingPeriod,
    @required this.stakeWarningPeriod,
    @required this.stakingRule,
    @required this.date,
  });

  EarnRuleStakingResponseModel.fromJson(Map<String, dynamic> json)
      : referralId = json['ReferralId'],
        referralName = json['ReferralName'],
        stakeAmount = TokenCurrency(value: json['StakeAmount']),
        totalReward = TokenCurrency(value: json['TotalReward']),
        stakingPeriod = json['StakingPeriod'],
        stakeWarningPeriod = json['StakeWarningPeriod'],
        stakingRule = json['StakingRule'],
        date = json['Timestamp'];

  static List<EarnRuleStakingResponseModel> toListOf(List list) => list == null
      ? []
      : list
          .map((item) => EarnRuleStakingResponseModel.fromJson(item))
          .toList();

  final String referralId;
  final String referralName;
  final TokenCurrency stakeAmount;
  final TokenCurrency totalReward;
  final int stakingPeriod;
  final int stakeWarningPeriod;
  final double stakingRule;
  final String date;
}

class EarnRuleStakingListResponseModel {
  EarnRuleStakingListResponseModel({this.totalCount, this.earnRuleStakings});

  EarnRuleStakingListResponseModel.fromJson(Map<String, dynamic> json)
      : totalCount = json['TotalCount'],
        earnRuleStakings =
            EarnRuleStakingResponseModel.toListOf(json['EarnRuleStakings']);

  final int totalCount;
  final List<EarnRuleStakingResponseModel> earnRuleStakings;
}

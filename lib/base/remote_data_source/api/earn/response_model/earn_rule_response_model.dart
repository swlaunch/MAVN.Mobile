import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_condition_response_model.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

class EarnRule {
  const EarnRule({
    @required this.id,
    @required this.title,
    @required this.status,
    @required this.description,
    @required this.imageUrl,
    @required this.reward,
    @required this.rewardType,
    @required this.fromDate,
    @required this.toDate,
    @required this.createdBy,
    @required this.creationDate,
    @required this.completionCount,
    @required this.conditions,
    @required this.optionalConditions,
    @required this.isApproximate,
    this.approximateAward,
  });

  EarnRule.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        title = json['Title'],
        status = EnumMapper.mapFromString(json['Status'],
            enumValues: EarnRuleStatus.values,
            defaultValue: EarnRuleStatus.inactive),
        description = json['Description'],
        imageUrl = json['ImageUrl'],
        reward = TokenCurrency(value: json['Reward']),
        approximateAward = TokenCurrency(value: json['ApproximateAward']),
        isApproximate = json['IsApproximate'] ?? false,
        rewardType = EnumMapper.mapFromString(json['RewardType'],
            enumValues: RewardType.values, defaultValue: RewardType.fixed),
        fromDate = json['FromDate'],
        toDate = json['ToDate'],
        createdBy = json['CreatedBy'],
        creationDate = json['CreationDate'],
        completionCount = json['CompletionCount'],
        conditions =
            EarnRuleCondition.toListFromJson(json['Conditions'] as List),
        optionalConditions = EarnRuleCondition.toListFromJson(
            json['OptionalConditions'] as List);

  final String id;
  final String title;
  final EarnRuleStatus status;
  final String description;
  final String imageUrl;
  final TokenCurrency reward;
  final TokenCurrency approximateAward;
  final bool isApproximate;
  final RewardType rewardType;
  final String fromDate;
  final String toDate;
  final String createdBy;
  final String creationDate;
  final int completionCount;
  final List<EarnRuleCondition> conditions;
  final List<EarnRuleCondition> optionalConditions;
}

enum EarnRuleStatus { pending, active, completed, inactive }

enum RewardType { fixed, percentage, conversionRate }

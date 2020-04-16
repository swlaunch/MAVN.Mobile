import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';

class EarnRuleListResponseModel extends Equatable {
  const EarnRuleListResponseModel({
    @required this.earnRuleList,
    @required this.totalCount,
    @required this.currentPage,
  });

  EarnRuleListResponseModel.fromJson(Map<String, dynamic> json)
      : earnRuleList = (json['EarnRules'] as List)
            .map((earnRuleJson) => EarnRule.fromJson(earnRuleJson))
            .toList(),
        totalCount = json['TotalCount'],
        currentPage = json['CurrentPage'];

  final List<EarnRule> earnRuleList;

  final int totalCount;

  final int currentPage;

  @override
  List<Object> get props => [earnRuleList, totalCount, currentPage];
}

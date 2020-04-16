import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_staking_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class EarnApi extends BaseApi {
  EarnApi(HttpClient httpClient) : super(httpClient);

//region paths
  static const String earnRuleListPath = '/earnRules?statuses=Active';
  static const String earnRuleByIdPath = '/earnRules/search';
  static const String earnRuleStakings = '/earnRules/staking';

  //endregion paths

  //region query parameters
  static const String currentPageQueryParameterKey = 'CurrentPage';
  static const String pageSizeQueryParameterKey = 'PageSize';
  static const String earnRuleIdQueryParameterKey = 'earnRuleId';

  //region query parameters

  Future<EarnRuleListResponseModel> getEarnRules({
    @required int currentPage,
    @required int pageSize,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        final earnRuleListResponse =
            await httpClient.get(earnRuleListPath, queryParameters: {
          currentPageQueryParameterKey: currentPage,
          pageSizeQueryParameterKey: pageSize,
        });

        return EarnRuleListResponseModel.fromJson(earnRuleListResponse.data);
      });

  Future<ExtendedEarnRule> getEarnRuleById({
    @required String earnRuleId,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get(
          earnRuleByIdPath,
          queryParameters: {
            earnRuleIdQueryParameterKey: earnRuleId,
          },
        );

        return ExtendedEarnRule.fromJson(response.data);
      });

  Future<EarnRuleStakingListResponseModel> getEarnRuleStakings(
          {@required String earnRuleId}) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get(
          earnRuleStakings,
          queryParameters: {
            earnRuleIdQueryParameterKey: earnRuleId,
          },
        );

        return EarnRuleStakingListResponseModel.fromJson(response.data);
      });
}

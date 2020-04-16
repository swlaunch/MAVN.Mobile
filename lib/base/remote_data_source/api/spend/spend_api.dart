import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/real_estate_payment_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_purchase_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class SpendApi extends BaseApi {
  SpendApi(HttpClient httpClient) : super(httpClient);

//region paths

  static const String spendRuleListPath = '/spendRules';
  static const String spendRuleByIdPath = '/spendRules/search';
  static const String purchaseVoucherPath = '/vouchers/buy';

  static const String realEstatePropertiesPath = '/realEstate/properties';
  static const String realEstatePaymentPath = '/realEstate';

  //endregion paths

  //region query parameters
  static const String currentPageQueryParameterKey = 'CurrentPage';
  static const String pageSizeQueryParameterKey = 'PageSize';
  static const String spendRuleIdQueryParameterKey = 'spendRuleId';
  static const String pushRegistrationTokenQueryParameterKey =
      'PushRegistrationToken';

  //region query parameters

  Future<SpendRuleListResponseModel> getSpendRules({
    @required int currentPage,
    @required int pageSize,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get(
          spendRuleListPath,
          queryParameters: {
            currentPageQueryParameterKey: currentPage,
            pageSizeQueryParameterKey: pageSize,
          },
        );

        return SpendRuleListResponseModel.fromJson(response.data);
      });

  Future<SpendRule> getSpendRuleById({
    @required String spendRuleId,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get(spendRuleByIdPath,
            queryParameters: {spendRuleIdQueryParameterKey: spendRuleId});

        return SpendRule.fromJson(response.data);
      });

  Future<VoucherPurchaseResponseModel> purchaseVoucher({
    @required String spendRuleId,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.post<Map<String, dynamic>>(
          purchaseVoucherPath,
          queryParameters: {
            spendRuleIdQueryParameterKey: spendRuleId,
          },
        );

        return VoucherPurchaseResponseModel.fromJson(response.data);
      });

  Future<RealEstatePropertyListResponseModel> getProperties({
    @required String spendRuleId,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get(realEstatePropertiesPath,
            queryParameters: {spendRuleIdQueryParameterKey: spendRuleId});

        return RealEstatePropertyListResponseModel.fromJson(response.data);
      });

  Future<void> postRealEstatePayment(
    RealEstatePaymentRequestModel realEstatePaymentRequestModel,
  ) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          realEstatePaymentPath,
          data: realEstatePaymentRequestModel.toJson(),
        );
      });
}

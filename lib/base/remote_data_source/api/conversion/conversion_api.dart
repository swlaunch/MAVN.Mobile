import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/response_model/conversion_rate_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/response_model/currency_converter_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class ConversionApi extends BaseApi {
  ConversionApi(HttpClient httpClient) : super(httpClient);

  static const String currencyConverterPath =
      '/currencyConverter/tokens/baseCurrency';
  static const String partnerConversionRatePath = '/conversionRate/partner';
  static const String spendRuleConversionRatePath = '/conversionRate/burnRule';

  static const String amountQueryParameterKey = 'Amount';
  static const String partnerIdQueryParameterKey = 'PartnerId';
  static const String spendRuleIdQueryParameterKey = 'BurnRuleId';

  Future<CurrencyConverterResponseModel> convertTokensToBaseCurrency(
          double amount) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get<Map<String, dynamic>>(
            currencyConverterPath,
            queryParameters: {amountQueryParameterKey.toLowerCase(): amount});

        return CurrencyConverterResponseModel.fromJson(response.data);
      });

  Future<ConversionRateResponseModel> getPartnerConversionRate(
          String partnerId, String amount) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get<Map<String, dynamic>>(
          partnerConversionRatePath,
          queryParameters: {
            partnerIdQueryParameterKey: partnerId,
            amountQueryParameterKey: amount,
          },
        );

        return ConversionRateResponseModel.fromJson(response.data);
      });

  Future<ConversionRateResponseModel> getSpendRuleConversionRate(
          String spendRuleId, String amount) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get<Map<String, dynamic>>(
          spendRuleConversionRatePath,
          queryParameters: {
            spendRuleIdQueryParameterKey: spendRuleId,
            amountQueryParameterKey: amount,
          },
        );

        return ConversionRateResponseModel.fromJson(response.data);
      });
}

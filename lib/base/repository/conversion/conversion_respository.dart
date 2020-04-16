import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/conversion_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/response_model/conversion_rate_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/response_model/currency_converter_response_model.dart';

class ConversionRepository {
  ConversionRepository(this._conversionApi);

  final ConversionApi _conversionApi;

  Future<CurrencyConverterResponseModel> convertTokensToBaseCurrency({
    double amountInTokens,
  }) =>
      _conversionApi.convertTokensToBaseCurrency(
        amountInTokens,
      );

  Future<ConversionRateResponseModel> getPartnerConversionRate({
    String partnerId,
    String amountInTokens,
  }) =>
      _conversionApi.getPartnerConversionRate(
        partnerId,
        amountInTokens,
      );

  Future<ConversionRateResponseModel> getSpendRuleConversionRate({
    String spendRuleId,
    String amountInTokens,
  }) =>
      _conversionApi.getSpendRuleConversionRate(
        spendRuleId,
        amountInTokens,
      );
}

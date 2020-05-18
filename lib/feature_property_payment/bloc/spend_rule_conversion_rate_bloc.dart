import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/conversion/conversion_respository.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/spend_rule_conversion_rate_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/di/property_payment_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';

export 'package:lykke_mobile_mavn/feature_property_payment/bloc/spend_rule_conversion_rate_bloc_output.dart';

class SpendRuleConversionRateBloc extends Bloc<SpendRuleConversionRateState> {
  SpendRuleConversionRateBloc(
    this._conversionRepository,
    this._exceptionToMessageMapper,
  );

  final ConversionRepository _conversionRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  SpendRuleConversionRateState initialState() =>
      SpendRuleConversionRateUninitializedState();

  Future<void> getSpendRuleConversionRate({
    String spendRuleId,
    String amountOfToken,
  }) async {
    setState(SpendRuleConversionRateLoadingState());

    try {
      final conversionRateResponse =
          await _conversionRepository.getSpendRuleConversionRate(
        spendRuleId: spendRuleId,
        amountInTokens: amountOfToken,
      );

      setState(SpendRuleConversionRateLoadedState(
        rate: NumberFormatter.tryParseDecimal(conversionRateResponse.amount),
        currencyCode: conversionRateResponse.currencyCode,
      ));
    } on Exception catch (e) {
      setState(
          SpendRuleConversionRateErrorState(_exceptionToMessageMapper.map(e)));
    }
  }
}

SpendRuleConversionRateBloc useSpendRuleConversionRateBloc() =>
    ModuleProvider.of<PropertyPaymentModule>(useContext())
        .spendRuleConversionRateBloc;

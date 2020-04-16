import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/conversion/conversion_respository.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/partner_conversion_rate_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/di/payment_request_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';

export 'package:lykke_mobile_mavn/feature_payment_request/bloc/partner_conversion_rate_bloc_output.dart';

class PartnerConversionRateBloc extends Bloc<PartnerConversionRateState> {
  PartnerConversionRateBloc(
    this._conversionRepository,
    this._exceptionToMessageMapper,
  );

  final ConversionRepository _conversionRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  PartnerConversionRateState initialState() =>
      PartnerConversionRateUninitializedState();

  Future<void> getPartnerConversionRate({
    String partnerId,
    String amountOfToken,
  }) async {
    setState(PartnerConversionRateLoadingState());

    try {
      final conversionRateResponse =
          await _conversionRepository.getPartnerConversionRate(
        partnerId: partnerId,
        amountInTokens: amountOfToken,
      );

      setState(PartnerConversionRateLoadedState(
        rate: NumberFormatter.tryParseDecimal(conversionRateResponse.amount),
        currencyCode: conversionRateResponse.currencyCode,
      ));
    } on Exception catch (e) {
      setState(
          PartnerConversionRateErrorState(_exceptionToMessageMapper.map(e)));
    }
  }
}

PartnerConversionRateBloc usePartnerConversionRateBloc() =>
    ModuleProvider.of<PaymentRequestModule>(useContext())
        .partnerConversionRateBloc;

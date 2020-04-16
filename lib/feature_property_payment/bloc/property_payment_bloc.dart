import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/spend/spend_repository.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_payment_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/di/property_payment_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';

export 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_payment_bloc_output.dart';

class PropertyPaymentBloc extends Bloc<PropertyPaymentState> {
  PropertyPaymentBloc(
    this._spendRepository,
    this._exceptionToMessageMapper,
  );

  final SpendRepository _spendRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  PropertyPaymentState initialState() => PropertyPaymentUninitializedState();

  Future<void> sendPayment({
    @required String id,
    @required String instalmentName,
    @required String spendRuleId,
    String amountInToken,
    FiatCurrency amountInCurrency,
    AmountSize amountSize,
  }) async {
    setState(PropertyPaymentLoadingState());

    try {
      await _spendRepository.submitPropertyPayment(
        id: id,
        instalmentName: instalmentName,
        spendRuleId: spendRuleId,
        //if user pays full, we send null to BE
        amountInTokens: amountSize == AmountSize.partial ? amountInToken : null,
        //if user pays partial, send null to BE
        amountInFiat: amountSize == AmountSize.full
            ? amountInCurrency.decimalValue.toDouble()
            : null,
        fiatCurrencyCode: amountInCurrency.assetSymbol,
      );
      sendEvent(PropertyPaymentSuccessEvent());
    } on Exception catch (e) {
      setState(_mapExceptionToErrorMessage(e));
    }
  }

  PropertyPaymentState _mapExceptionToErrorMessage(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is ServiceException) {
      if (e.exceptionType == ServiceExceptionType.customerWalletBlocked) {
        sendEvent(PropertyPaymentWalletDisabledEvent());
      }
      return PropertyPaymentInlineErrorState(errorMessage);
    }

    return PropertyPaymentErrorState(errorMessage);
  }
}

PropertyPaymentBloc usePropertyPaymentBloc() =>
    ModuleProvider.of<PropertyPaymentModule>(useContext()).propertyPaymentBloc;

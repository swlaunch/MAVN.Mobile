import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/di/property_payment_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_payment_bloc_output.dart';

class PropertyPaymentAmountBloc extends Bloc<PropertyPaymentAmountState> {
  @override
  PropertyPaymentAmountState initialState() =>
      PropertyPaymentAmountUninitializedState();

  ///Set the full amount once it is known
  Future<void> initialize({String fullAmount}) async {
    setState(PropertyPaymentSelectedAmountState(
      amount: fullAmount,
      fullAmount: fullAmount,
      userInputAmount: '',
      amountSize: AmountSize.full,
    ));
    sendEvent(PropertyPaymentUpdatedAmountEvent(amount: fullAmount));
  }

  Future<void> switchAmountSize(AmountSize amountSize) async {
    if (currentState is PropertyPaymentSelectedAmountState) {
      final selectedAmountState =
          currentState as PropertyPaymentSelectedAmountState;

      final amount = amountSize == AmountSize.full
          ? selectedAmountState.fullAmount
          : selectedAmountState.userInputAmount;

      setState(PropertyPaymentSelectedAmountState(
        amount: amount,
        fullAmount: selectedAmountState.fullAmount,
        userInputAmount: selectedAmountState.userInputAmount,
        amountSize: amountSize,
      ));

      sendEvent(PropertyPaymentUpdatedAmountEvent(amount: amount));
    }
  }

  Future<void> setAmount(String amount) async {
    if (currentState is PropertyPaymentSelectedAmountState) {
      final selectedAmountState =
          currentState as PropertyPaymentSelectedAmountState;

      if (selectedAmountState.amountSize == AmountSize.full) {
        return;
      }
      setState(
        PropertyPaymentSelectedAmountState(
          amount: amount,
          fullAmount: selectedAmountState.fullAmount,
          userInputAmount: amount,
          amountSize: selectedAmountState.amountSize,
        ),
      );
    }
  }
}

PropertyPaymentAmountBloc usePropertyPaymentAmountBloc() =>
    ModuleProvider.of<PropertyPaymentModule>(useContext())
        .propertyPaymentAmountBloc;

enum AmountSize { full, partial }

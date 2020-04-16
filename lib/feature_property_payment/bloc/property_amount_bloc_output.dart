import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class PropertyPaymentAmountState extends BlocState {}

class PropertyPaymentAmountUninitializedState
    extends PropertyPaymentAmountState {}

class PropertyPaymentSelectedAmountState extends PropertyPaymentAmountState {
  PropertyPaymentSelectedAmountState({
    this.amount,
    this.fullAmount,
    this.userInputAmount,
    this.amountSize,
  });
  final String amount;
  final String fullAmount;
  final String userInputAmount;
  final AmountSize amountSize;

  @override
  List get props => super.props
    ..addAll([
      amount,
      fullAmount,
      userInputAmount,
      amountSize,
    ]);
}

class PropertyPaymentUpdatedAmountEvent extends BlocEvent {
  PropertyPaymentUpdatedAmountEvent({this.amount});

  final String amount;

  @override
  List get props => super.props..addAll([amount]);
}

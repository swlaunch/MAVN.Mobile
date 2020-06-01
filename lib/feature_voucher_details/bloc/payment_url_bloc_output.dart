import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class PaymentUrlState extends BlocState {}

class PaymentUrlUninitializedState extends PaymentUrlState {}

class PaymentUrlLoadingState extends PaymentUrlState {}

class PaymentUrlLoadedState extends PaymentUrlState {}

class PaymentUrlSuccessEvent extends BlocEvent {
  PaymentUrlSuccessEvent({@required this.paymentUrl});

  final String paymentUrl;

  @override
  List get props => super.props..addAll([paymentUrl]);
}

class PaymentUrlErrorState extends PaymentUrlState {
  PaymentUrlErrorState({@required this.error});

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class PaymentUrlNetworkErrorState extends PaymentUrlState {
  PaymentUrlNetworkErrorState();
}

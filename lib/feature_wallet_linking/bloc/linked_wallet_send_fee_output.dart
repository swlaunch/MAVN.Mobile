import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class LinkedWalletSendFeeState extends BaseState {}

abstract class LinkedWalletSendFeeEvent extends BlocEvent {}

class LinkedWalletSendFeeUninitializedState extends LinkedWalletSendFeeState {}

class LinkedWalletSendFeeLoadingState extends LinkedWalletSendFeeState {}

class LinkedWalletSendFeeErrorState extends LinkedWalletSendFeeState {
  LinkedWalletSendFeeErrorState(this.message);

  final LocalizedStringBuilder message;

  @override
  List get props => [message];
}

class LinkedWalletSendFeeErrorEvent extends LinkedWalletSendFeeEvent {
  LinkedWalletSendFeeErrorEvent(this.message);

  final String message;

  @override
  List get props => [message];
}

class LinkedWalletSendFeeLoadedState extends LinkedWalletSendFeeState {
  LinkedWalletSendFeeLoadedState({
    @required this.rate,
    @required this.fee,
    @required this.baseCurrency,
  });

  final Decimal rate;
  final String fee;
  final String baseCurrency;

  @override
  List get props => [rate, fee, baseCurrency];
}

class LinkedWalletSendFeeLoadedEvent extends LinkedWalletSendFeeEvent {
  LinkedWalletSendFeeLoadedEvent();
}

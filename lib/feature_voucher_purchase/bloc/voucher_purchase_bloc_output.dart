import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class VoucherPurchaseState extends BlocState {}

class VoucherPurchaseUninitializedState extends VoucherPurchaseState {}

class VoucherPurchaseLoadingState extends VoucherPurchaseState {}

class VoucherPurchaseLoadedState extends VoucherPurchaseState {}

class VoucherPurchaseSuccessEvent extends BlocEvent {
  VoucherPurchaseSuccessEvent({@required this.paymentUrl});

  final String paymentUrl;

  @override
  List get props => super.props..addAll([paymentUrl]);
}

class VoucherPurchaseErrorState extends VoucherPurchaseState {
  VoucherPurchaseErrorState({@required this.error});

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class VoucherPurchaseNetworkErrorState extends VoucherPurchaseState {
  VoucherPurchaseNetworkErrorState();
}

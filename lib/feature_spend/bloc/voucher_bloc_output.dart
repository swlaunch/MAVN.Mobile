import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class VoucherPurchaseState extends BlocState {}

class VoucherPurchaseUninitializedState extends VoucherPurchaseState {}

class VoucherPurchaseInProgressState extends VoucherPurchaseState {}

class VoucherPurchaseSuccessEvent extends BlocEvent {
  VoucherPurchaseSuccessEvent({@required this.voucherCode});

  final String voucherCode;

  @override
  List get props => super.props..addAll([voucherCode]);
}

class VoucherPurchaseErrorState extends VoucherPurchaseState {
  VoucherPurchaseErrorState({@required this.error});

  final String error;

  @override
  List get props => super.props..addAll([error]);
}

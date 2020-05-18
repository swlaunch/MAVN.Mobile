import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import '../../base/common_blocs/base_bloc_output.dart';

abstract class PaymentRequestState extends BaseState {}

abstract class PaymentRequestEvent extends BlocEvent {}

class PaymentRequestUninitializedState extends PaymentRequestState {}

class PaymentRequestLoadingState extends PaymentRequestState
    with BaseLoadingState {}

class PaymentRequestErrorState extends PaymentRequestState
    with BaseDetailedErrorState {
  PaymentRequestErrorState({
    @required this.errorTitle,
    @required this.errorSubtitle,
    @required this.iconAsset,
  });

  final String errorTitle;
  final String errorSubtitle;
  final String iconAsset;

  @override
  String get title => errorTitle;

  @override
  String get subtitle => errorSubtitle;

  @override
  String get asset => iconAsset;

  @override
  List get props => super.props..addAll([errorTitle, errorSubtitle, iconAsset]);
}

class PaymentRequestInlineErrorState extends PaymentRequestState
    with BaseInlineErrorState {
  PaymentRequestInlineErrorState({@required this.error});

  final String error;

  @override
  String get errorMessage => error;
}

class PaymentRequestApprovedSuccessEvent extends PaymentRequestEvent {}

class PaymentRequestRejectedSuccessEvent extends PaymentRequestEvent {}

class PaymentRequestWalletDisabledEvent extends PaymentRequestEvent {}

class PaymentRequestExpiredEvent extends PaymentRequestEvent {}

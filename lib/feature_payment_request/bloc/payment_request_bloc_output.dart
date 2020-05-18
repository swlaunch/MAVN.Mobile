import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
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

  final LocalizedStringBuilder errorTitle;
  final LocalizedStringBuilder errorSubtitle;
  final String iconAsset;

  @override
  LocalizedStringBuilder get title => errorTitle;

  @override
  LocalizedStringBuilder get subtitle => errorSubtitle;

  @override
  String get asset => iconAsset;

  @override
  List get props => super.props..addAll([errorTitle, errorSubtitle, iconAsset]);
}

class PaymentRequestInlineErrorState extends PaymentRequestState
    with BaseInlineErrorState {
  PaymentRequestInlineErrorState({@required this.error});

  final LocalizedStringBuilder error;

  @override
  LocalizedStringBuilder get errorMessage => error;
}

class PaymentRequestApprovedSuccessEvent extends PaymentRequestEvent {}

class PaymentRequestRejectedSuccessEvent extends PaymentRequestEvent {}

class PaymentRequestWalletDisabledEvent extends PaymentRequestEvent {}

class PaymentRequestExpiredEvent extends PaymentRequestEvent {}

import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import '../../base/common_blocs/base_bloc_output.dart';

abstract class PaymentRequestDetailsState extends BaseState {}

class PaymentRequestDetailsUninitializedState
    extends PaymentRequestDetailsState {}

class PaymentRequestDetailsLoadingState extends PaymentRequestDetailsState
    with BaseLoadingState {}

class PaymentRequestDetailsLoadedState extends PaymentRequestDetailsState {
  PaymentRequestDetailsLoadedState({@required this.payment});

  final PaymentRequestResponseModel payment;
}

class PaymentRequestDetailsErrorState extends PaymentRequestDetailsState
    with BaseDetailedErrorState {
  PaymentRequestDetailsErrorState({
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

class PaymentRequestDetailsLoadedEvent extends BlocEvent {
  PaymentRequestDetailsLoadedEvent({@required this.payment});

  final PaymentRequestResponseModel payment;
}

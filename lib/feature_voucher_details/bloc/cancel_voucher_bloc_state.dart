import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class CancelVoucherState extends BaseState {}

class CancelVoucherUninitializedState extends CancelVoucherState {}

class CancelVoucherLoadingState extends CancelVoucherState
    with BaseLoadingState {}

class CancelVoucherLoadedState extends CancelVoucherState {}

class CancelVoucherSuccessEvent extends BlocEvent {}

class CancelVoucherErrorState extends CancelVoucherState {
  CancelVoucherErrorState({@required this.error});

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class CancelVoucherNetworkErrorState extends CancelVoucherState
    with BaseNetworkErrorState {
  CancelVoucherNetworkErrorState();
}

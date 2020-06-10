import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class InvalidateVoucherState extends BaseState {}

class InvalidateVoucherUninitializedState extends InvalidateVoucherState {}

class InvalidateVoucherLoadingState extends InvalidateVoucherState
    with BaseLoadingState {}

class InvalidateVoucherLoadedState extends InvalidateVoucherState {}

class InvalidateVoucherSuccessEvent extends BlocEvent {}

class InvalidateVoucherErrorState extends InvalidateVoucherState {
  InvalidateVoucherErrorState({@required this.error});

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class InvalidateVoucherNetworkErrorState extends InvalidateVoucherState
    with BaseNetworkErrorState {
  InvalidateVoucherNetworkErrorState();
}

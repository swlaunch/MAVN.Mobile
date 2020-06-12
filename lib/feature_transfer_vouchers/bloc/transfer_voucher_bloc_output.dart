import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class TransferVoucherState extends BlocState {}

class TransferVoucherUninitializedState extends TransferVoucherState {
  TransferVoucherUninitializedState();
}

class TransferVoucherLoadingState extends TransferVoucherState {}

class TransferVoucherNetworkErrorState extends TransferVoucherState {}

class TransferVoucherErrorState extends TransferVoucherState {
  TransferVoucherErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class TransferVoucherSuccessEvent extends BlocEvent {}

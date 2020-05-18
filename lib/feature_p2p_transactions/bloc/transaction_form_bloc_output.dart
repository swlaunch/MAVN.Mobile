import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class TransactionFormState extends BlocState {}

class TransactionFormUninitializedState extends TransactionFormState {
  TransactionFormUninitializedState();
}

class TransactionFormLoadingState extends TransactionFormState {}

class TransactionFormErrorState extends TransactionFormState {
  TransactionFormErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class TransactionFormInlineErrorState extends TransactionFormState {
  TransactionFormInlineErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class TransactionFormWalletDisabledEvent extends BlocEvent {}

class TransactionFormSuccessEvent extends BlocEvent {}

class BarcodeUninitializedState extends TransactionFormState {}

class BarcodeScanSuccessEvent extends BlocEvent {
  BarcodeScanSuccessEvent(this.barcode);

  final String barcode;

  @override
  List get props => super.props..addAll([barcode]);
}

class BarcodeScanPermissionErrorState extends TransactionFormState {
  BarcodeScanPermissionErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class BarcodeScanErrorState extends TransactionFormState {
  BarcodeScanErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

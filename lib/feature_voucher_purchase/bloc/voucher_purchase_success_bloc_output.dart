import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class VoucherPurchaseSuccessState extends BlocState {}

class VoucherPurchaseSuccessUninitializedState
    extends VoucherPurchaseSuccessState {}

class VoucherPurchaseSuccessLoadingState extends VoucherPurchaseSuccessState {}

class VoucherPurchaseSuccessSuccessState extends VoucherPurchaseSuccessState {}

class VoucherPurchaseSuccessErrorState extends VoucherPurchaseSuccessState {
  VoucherPurchaseSuccessErrorState({@required this.error});

  final LocalizedStringBuilder error;
}

class VoucherPurchaseSuccessStoredKey extends BlocEvent {}

class VoucherPurchaseSuccessSuccessEvent extends BlocEvent {}

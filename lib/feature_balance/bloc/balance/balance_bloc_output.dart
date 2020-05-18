import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/response_model/currency_converter_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class BalanceState extends BaseState {}

abstract class BalanceBaseErrorState extends BalanceState {}

class BalanceUninitializedState extends BalanceState {}

class BalanceLoadingState extends BalanceState with BaseLoadingState {}

class BalanceErrorState extends BalanceBaseErrorState {
  BalanceErrorState({
    @required this.errorTitle,
    @required this.errorSubtitle,
    @required this.iconAsset,
  });

  final LocalizedStringBuilder errorTitle;
  final LocalizedStringBuilder errorSubtitle;
  final String iconAsset;

  @override
  List get props => super.props..addAll([errorTitle, errorSubtitle, iconAsset]);
}

class BalanceNetworkErrorState extends BalanceBaseErrorState
    with BaseNetworkErrorState {}

class BalanceLoadedState extends BalanceState {
  BalanceLoadedState({
    @required this.wallet,
    this.conversionRateAmount,
    this.currencyCode,
    this.isWalletDisabled,
  });

  final WalletResponseModel wallet;
  final CurrencyConverterResponseModel conversionRateAmount;
  final String currencyCode;
  final bool isWalletDisabled;

  BalanceLoadedState copyWithIsWalletDisabled({bool isWalletDisabled}) =>
      BalanceLoadedState(
        wallet: wallet,
        conversionRateAmount: conversionRateAmount,
        currencyCode: currencyCode,
        isWalletDisabled: isWalletDisabled,
      );
}

class BalanceUpdatedEvent extends BlocEvent {}

import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:meta/meta.dart';

abstract class WalletState extends BaseState {}

class WalletUninitializedState extends WalletState {}

class WalletLoadingState extends WalletState with BaseLoadingState {}

class WalletLoadedState extends WalletState {
  WalletLoadedState({
    @required this.wallet,
    @required this.externalBalanceInBaseCurrency,
    @required this.baseCurrencyCode,
  });

  final WalletResponseModel wallet;
  final String externalBalanceInBaseCurrency;
  final String baseCurrencyCode;

  @override
  List get props => [wallet, externalBalanceInBaseCurrency];
}

class WalletErrorState extends WalletState with BaseInlineErrorState {
  WalletErrorState({@required this.errorMessage});

  @override
  LocalizedStringBuilder errorMessage;

  @override
  List get props => super.props..addAll([errorMessage]);
}

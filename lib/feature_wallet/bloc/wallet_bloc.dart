import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/conversion/conversion_respository.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class WalletBloc extends Bloc<WalletState> {
  WalletBloc(
    this._walletRepository,
    this._conversionRepository,
    this._getMobileSettingsUseCase,
    this._exceptionToMessageMapper,
  );

  final WalletRepository _walletRepository;
  final ConversionRepository _conversionRepository;
  final GetMobileSettingsUseCase _getMobileSettingsUseCase;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  WalletState initialState() => WalletUninitializedState();

  Future<void> fetchWallet() async {
    setState(WalletLoadingState());

    try {
      final wallet = await _walletRepository.getWallet();
      final externalBalanceInBase = await _getExternalBalanceInBase(wallet);
      final baseCurrencyCode =
          _getMobileSettingsUseCase.execute()?.baseCurrency;

      setState(WalletLoadedState(
        wallet: wallet,
        externalBalanceInBaseCurrency: externalBalanceInBase,
        baseCurrencyCode: baseCurrencyCode,
      ));
    } on Exception catch (e) {
      setState(
          WalletErrorState(errorMessage: _exceptionToMessageMapper.map(e)));
    }
  }

  Future<String> _getExternalBalanceInBase(
      WalletResponseModel fromWallet) async {
    final externalBalance = fromWallet?.externalBalance?.doubleValue;

    if (externalBalance == null) {
      return null;
    }

    final currencyModel = await _conversionRepository
        .convertTokensToBaseCurrency(amountInTokens: externalBalance);

    return currencyModel.amount;
  }
}

WalletBloc useWalletBloc() =>
    ModuleProvider.of<AppModule>(useContext()).walletBloc;

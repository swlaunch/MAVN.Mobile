import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/response_model/currency_converter_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/balance_repository/balance_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/conversion/conversion_respository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc_output.dart';

class BalanceBloc extends Bloc<BalanceState> {
  BalanceBloc(this._conversionRepository, this._walletRealTimeRepository,
      this._tokenRepository, this._getMobileSettingsUseCase);

  final ConversionRepository _conversionRepository;
  final WalletRealTimeRepository _walletRealTimeRepository;
  final TokenRepository _tokenRepository;
  final GetMobileSettingsUseCase _getMobileSettingsUseCase;

  StreamSubscription _walletUpdatesSubscription;

  static const _retryTimerInitialSeconds = 1;
  static const _retryTimerMaxSeconds = 30;
  int _retryTimerSeconds = _retryTimerInitialSeconds;

  CancelableOperation _retryOperation;

  bool _isPaused = false;
  bool _isLoggedOut = false;
  bool _isWalletDisabled = false;

  @override
  BalanceState initialState() => BalanceUninitializedState();

  void logout() {
    _isLoggedOut = true;
    _retryOperation?.cancel();
    _walletRealTimeRepository.disconnect();
    _walletUpdatesSubscription?.cancel();
  }

  @override
  void dispose() {
    _retryOperation?.cancel();
    _walletRealTimeRepository.disconnect();
    _walletUpdatesSubscription?.cancel();
    super.dispose();
  }

  void pause() {
    _isPaused = true;
    _walletRealTimeRepository.disconnect();
  }

  void resume() {
    _isPaused = false;
    _walletRealTimeRepository.reconnect();
  }

  Future<void> retry() async {
    await _retryOperation?.cancel();

    if (currentState is! BalanceLoadedState) {
      setState(BalanceLoadingState());
    }

    await _walletRealTimeRepository.reconnect();
  }

  Future<void> init() async {
    _isLoggedOut = false;

    setState(BalanceLoadingState());

    final token = await _tokenRepository.getLoginToken();

    _walletRealTimeRepository.init(token: token);

    final walletUpdatesStream =
        await _walletRealTimeRepository.getWalletUpdatesStream();

    await _walletUpdatesSubscription?.cancel();

    _walletUpdatesSubscription = walletUpdatesStream.listen(
      _handleWalletEvent,
      onError: _handleWalletError,
      cancelOnError: false,
    );
  }

  Future<void> _handleWalletEvent(WalletEvent walletEvent) async {
    if (walletEvent == null) {
      return;
    }

    await _retryOperation?.cancel();
    _retryTimerSeconds = _retryTimerInitialSeconds;

    if (walletEvent is WalletBalanceEvent) {
      await _handleWalletBalanceUpdate(walletEvent.data);
    }

    if (walletEvent is WalletStatusEvent) {
      _handleWalletDisabled(isWalletDisabled: walletEvent.data.isBlocked);
    }
  }

  Future<void> _handleWalletBalanceUpdate(
    WalletResponseModel data,
  ) async {
    final currencyCode = _getMobileSettingsUseCase.execute()?.baseCurrency;

    final conversionRateAmount =
        await _getAmountInBaseCurrency(data.balance.doubleValue);

    setState(BalanceLoadedState(
      wallet: data,
      conversionRateAmount: conversionRateAmount,
      currencyCode: currencyCode,
      isWalletDisabled: _isWalletDisabled,
    ));

    sendEvent(BalanceUpdatedEvent());
  }

  void _handleWalletDisabled({bool isWalletDisabled}) {
    _isWalletDisabled = isWalletDisabled;

    if (currentState is BalanceLoadedState) {
      setState(
        (currentState as BalanceLoadedState).copyWithIsWalletDisabled(
          isWalletDisabled: _isWalletDisabled,
        ),
      );
    }
  }

  Future<void> _handleWalletError(error) async {
    // Only show the error during the initial setup, before receiving a value
    // from the socket. If we already have a previous value sent from the
    // socket, and the socket connection drops, then try reconnecting while
    // showing the last value received
    if (currentState is BalanceLoadingState) {
      setState(_mapExceptionToErrorState(e is Exception ? e : Exception()));
    }

    if (_isPaused || _isLoggedOut) {
      return;
    }

    await _retryOperation?.cancel();

    _retryOperation = CancelableOperation.fromFuture(
        Future.delayed(Duration(seconds: _retryTimerSeconds), () => true));

    if (await _retryOperation.valueOrCancellation(false)) {
      _retryTimerSeconds = min(_retryTimerMaxSeconds, _retryTimerSeconds * 2);

      if (!_isPaused && !_isLoggedOut) {
        await _walletRealTimeRepository.reconnect();
      }
    }
  }

  Future<CurrencyConverterResponseModel> _getAmountInBaseCurrency(
      double amount) async {
    try {
      return await _conversionRepository.convertTokensToBaseCurrency(
        amountInTokens: amount,
      );
    } catch (e) {
      return null;
    }
  }

  BalanceBaseErrorState _mapExceptionToErrorState(Exception e) {
    if (e is NetworkException) {
      return BalanceNetworkErrorState();
    }

    return BalanceErrorState(
      errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
      errorSubtitle: LazyLocalizedStrings.balanceBoxErrorMessage,
      iconAsset: SvgAssets.walletError,
    );
  }
}

BalanceBloc useBalanceBloc() =>
    ModuleProvider.of<AppModule>(useContext()).balanceBloc;

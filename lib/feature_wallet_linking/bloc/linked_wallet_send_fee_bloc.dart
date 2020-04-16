import 'package:decimal/decimal.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/conversion/conversion_respository.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/di/wallet_linking_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'linked_wallet_send_fee_output.dart';

class LinkedWalletSendFeeBloc extends Bloc<LinkedWalletSendFeeState> {
  LinkedWalletSendFeeBloc(
    this._conversionRepository,
    this._localSettingsRepository,
    this._exceptionToMessageMapper,
  );

  final ConversionRepository _conversionRepository;
  final LocalSettingsRepository _localSettingsRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  LinkedWalletSendFeeState initialState() =>
      LinkedWalletSendFeeUninitializedState();

  Future<void> fetchFee() async {
    try {
      setState(LinkedWalletSendFeeLoadingState());

      final rate = await _conversionRepository.convertTokensToBaseCurrency(
          amountInTokens: 1);

      setState(LinkedWalletSendFeeLoadedState(
        //TODO: make this fee dynamic when it's being exposed by the API
        fee: '1 ${_localSettingsRepository.getMobileSettings().tokenSymbol}',
        rate: Decimal.parse(rate.amount),
        baseCurrency: _localSettingsRepository.getMobileSettings().baseCurrency,
      ));
    } on Exception catch (exception) {
      setState(LinkedWalletSendFeeErrorState(
          _exceptionToMessageMapper.map(exception)));
    }
  }
}

LinkedWalletSendFeeBloc useLinkedWalletSendFeeBloc() =>
    ModuleProvider.of<WalletLinkingModule>(useContext())
        .linkedWalletSendFeeBloc;

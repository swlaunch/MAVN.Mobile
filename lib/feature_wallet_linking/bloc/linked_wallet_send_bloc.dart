import 'package:decimal/decimal.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/di/wallet_linking_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LinkedWalletSendBloc extends Bloc<LinkedWalletSendState> {
  LinkedWalletSendBloc(
    this._walletRepository,
    this._exceptionToMessageMapper,
  );

  final WalletRepository _walletRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  LinkedWalletSendState initialState() => LinkedWalletSendUninitializedState();

  Future<void> transferToken(Decimal amount) async {
    setState(LinkedWalletSendLoadingState());

    try {
      await _walletRepository.postExternalTransfer(amount);
      setState(LinkedWalletSendLoadedState());
      sendEvent(LinkedWalletSendLoadedEvent());
    } catch (e) {
      final message = _exceptionToMessageMapper.map(e);

      sendEvent(LinkedWalletSendErrorEvent(message));
      setState(LinkedWalletSendErrorState(message));
    }
  }
}

LinkedWalletSendBloc useLinkedWalletSendBloc() =>
    ModuleProvider.of<WalletLinkingModule>(useContext()).linkedWalletSendBloc;

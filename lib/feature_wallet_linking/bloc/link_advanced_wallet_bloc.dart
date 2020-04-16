import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_advanced_wallet_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/di/wallet_linking_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LinkAdvancedWalletBloc extends Bloc<LinkAdvancedWalletState> {
  LinkAdvancedWalletBloc(
    this._walletRepository,
    this._exceptionToMessageMapper,
  );

  final WalletRepository _walletRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  LinkAdvancedWalletState initialState() =>
      LinkAdvancedWalletUninitializedState();

  Future<void> linkPrivateWallet(
      {String publicAddress, String linkingCode}) async {
    setState(LinkAdvancedWalletLoadingState());

    try {
      final wallet = await _walletRepository.getWallet();
      final privateAddress = wallet.privateWalletAddress;

      await _walletRepository.approvePublicWalletLinkingRequest(
          privateAddress: privateAddress,
          publicAddress: publicAddress,
          signature: linkingCode);
      sendEvent(LinkAdvancedWalletSubmissionSuccessEvent());
    } catch (exception) {
      final errorMessage = _exceptionToMessageMapper.map(exception);
      sendEvent(LinkAdvancedWalletSubmissionErrorEvent(errorMessage));
      setState(LinkAdvancedWalletErrorState(errorMessage));
    }
  }
}

LinkAdvancedWalletBloc useLinkAdvancedWalletBloc() =>
    ModuleProvider.of<WalletLinkingModule>(useContext()).linkAdvancedWalletBloc;

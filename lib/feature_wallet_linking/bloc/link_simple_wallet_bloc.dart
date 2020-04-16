import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/response_model/link_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/di/wallet_linking_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'link_simple_wallet_output.dart';

class LinkSimpleWalletBloc extends Bloc<LinkSimpleWalletState> {
  LinkSimpleWalletBloc(
    this._mobileSettingsUseCase,
    this._walletRepository,
    this._exceptionToMessageMapper,
  );

  final GetMobileSettingsUseCase _mobileSettingsUseCase;
  final WalletRepository _walletRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  LinkSimpleWalletState initialState() => LinkSimpleWalletUninitializedState();

  Future<void> generateDAppURL() async {
    setState(LinkSimpleWalletLoadingState());

    try {
      final data = await Future.wait([
        _walletRepository.createPublicLinkCodeRequest(),
        _walletRepository.getWallet()
      ], eagerError: true);

      final code = data[0] as LinkCodeRequestResponseModel;
      final wallet = data[1] as WalletResponseModel;

      setState(LinkSimpleWalletLoadedState(
          _getDAppUrl(code.linkCode ?? '', wallet.privateWalletAddress ?? '')));
    } on Exception catch (exception) {
      setState(
          LinkSimpleWalletErrorState(_exceptionToMessageMapper.map(exception)));
    }
  }

  String _getDAppUrl(String linkCode, String internalAddress) =>
      _mobileSettingsUseCase
          .execute()
          .dAppMobileSettings
          .linkWalletAppUrlTemplate
          .replaceFirst('{linkCode}', linkCode)
          .replaceFirst('{internalAddress}', internalAddress);
}

LinkSimpleWalletBloc useLinkSimpleWalletBloc() =>
    ModuleProvider.of<WalletLinkingModule>(useContext()).linkSimpleWalletBloc;

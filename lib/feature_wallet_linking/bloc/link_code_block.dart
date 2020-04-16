import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_code_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/di/wallet_linking_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LinkCodeBloc extends Bloc<LinkCodeState> {
  LinkCodeBloc(
    this._walletRepository,
    this._exceptionToMessageMapper,
  );

  final WalletRepository _walletRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  LinkCodeState initialState() => LinkCodeUninitializedState();

  Future<void> generateLinkCode() async {
    setState(LinkCodeLoadingState());

    try {
      final data = await _walletRepository.createPublicLinkCodeRequest();

      setState(LinkCodeLoadedState(data.linkCode));
    } catch (exception) {
      setState(LinkCodeErrorState(_exceptionToMessageMapper.map(exception)));
    }
  }
}

LinkCodeBloc useLinkCodeBloc() =>
    ModuleProvider.of<WalletLinkingModule>(useContext()).linkCodeBloc;

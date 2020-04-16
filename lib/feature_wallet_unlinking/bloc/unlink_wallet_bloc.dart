import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/bloc/unlink_wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/di/wallet_unlinking_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class UnlinkWalletBloc extends Bloc<UnlinkWalletSubmissionState> {
  UnlinkWalletBloc(
    this._walletRepository,
    this._exceptionToMessageMapper,
  );

  final WalletRepository _walletRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  Future<void> unlinkExternalWallet() async {
    try {
      await _walletRepository.unlinkExternalWallet();
    } catch (exception) {
      final errorMessage = _exceptionToMessageMapper.map(exception);
      sendEvent(UnlinkWalletSubmissionErrorEvent(errorMessage));
    }
  }

  @override
  UnlinkWalletSubmissionState initialState() =>
      UnlinkWalletSubmissionUninitializedState();
}

UnlinkWalletBloc useUnlinkWalletBloc() =>
    ModuleProvider.of<WalletUnlinkingModule>(useContext()).unlinkWalletBloc;

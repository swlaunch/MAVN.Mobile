import 'package:lykke_mobile_mavn/feature_wallet_unlinking/bloc/unlink_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class WalletUnlinkingModule extends Module {
  UnlinkWalletBloc get unlinkWalletBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => UnlinkWalletBloc(get(), get()));
  }
}

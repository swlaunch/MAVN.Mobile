import 'package:lykke_mobile_mavn/feature_receive_token/bloc/p2p_receive_token_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class P2PReceiveTokenModule extends Module {
  P2pReceiveTokenBloc get p2pReceiveTokenBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => P2pReceiveTokenBloc(get(), get()));
  }
}

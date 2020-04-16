import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_advanced_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_code_block.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_simple_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_fee_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class WalletLinkingModule extends Module {
  LinkWalletBloc get linkWalletBloc => get();

  LinkSimpleWalletBloc get linkSimpleWalletBloc => get();

  LinkAdvancedWalletBloc get linkAdvancedWalletBloc => get();

  LinkCodeBloc get linkCodeBloc => get();

  LinkedWalletSendFeeBloc get linkedWalletSendFeeBloc => get();

  LinkedWalletSendBloc get linkedWalletSendBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => LinkWalletBloc(get()));
    provideSingleton(() => LinkSimpleWalletBloc(get(), get(), get()));
    provideSingleton(() => LinkAdvancedWalletBloc(get(), get()));
    provideSingleton(() => LinkCodeBloc(get(), get()));
    provideSingleton(() => LinkedWalletSendFeeBloc(get(), get(), get()));
    provideSingleton(() => LinkedWalletSendBloc(get(), get()));
  }
}

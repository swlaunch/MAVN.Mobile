import 'package:lykke_mobile_mavn/feature_voucher_wallet/bloc/voucher_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class VoucherWalletModule extends Module {
  VoucherListBloc get voucherListBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => VoucherListBloc(get()));
  }
}

import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class VoucherPurchaseModule extends Module {
  VoucherPurchaseBloc get voucherPurchaseBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => VoucherPurchaseBloc(get(), get()));
  }
}

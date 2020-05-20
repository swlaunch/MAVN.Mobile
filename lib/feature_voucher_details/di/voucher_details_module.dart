import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/voucher_details_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class VoucherDetailsModule extends Module {
  VoucherDetailsBloc get voucherDetailsBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => VoucherDetailsBloc(get()));
  }
}

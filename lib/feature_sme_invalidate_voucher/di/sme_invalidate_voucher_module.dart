import 'package:lykke_mobile_mavn/feature_sme_invalidate_voucher/bloc/invalidate_voucher_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SmeInvalidateVoucherModule extends Module {
  InvalidateVoucherBloc get invalidateVoucherBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => InvalidateVoucherBloc(get(), get()));
  }
}

import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/payment_url_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/voucher_details_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class VoucherDetailsModule extends Module {
  VoucherDetailsBloc get voucherDetailsBloc => get();

  PaymentUrlBloc get paymentUrlBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => VoucherDetailsBloc(get()));
    provideSingleton(() => PaymentUrlBloc(get(), get()));
  }
}

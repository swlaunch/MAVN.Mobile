import 'package:lykke_mobile_mavn/feature_payment_request/bloc/partner_conversion_rate_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PaymentRequestModule extends Module {
  PaymentRequestDetailsBloc get paymentRequestDetailsBloc => get();

  PaymentRequestBloc get paymentRequestBloc => get();

  PartnerConversionRateBloc get partnerConversionRateBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => PaymentRequestDetailsBloc(get()));

    provideSingleton(() => PaymentRequestBloc(get(), get()));

    provideSingleton(() => PartnerConversionRateBloc(get(), get()));
  }
}

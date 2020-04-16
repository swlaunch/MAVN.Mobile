import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/completed_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/failed_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PartnerPaymentsModule extends Module {
  CompletedPartnerPaymentsBloc get completedPartnerPaymentsBloc => get();

  FailedPartnerPaymentsBloc get failedPartnerPaymentsBloc => get();

  @override
  void provideInstances() {
    provideSingleton<CompletedPartnerPaymentsBloc>(
        () => CompletedPartnerPaymentsBloc(get()));
    provideSingleton<FailedPartnerPaymentsBloc>(
        () => FailedPartnerPaymentsBloc(get()));
  }
}

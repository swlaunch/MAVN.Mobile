import 'package:lykke_mobile_mavn/feature_referral_list/bloc/completed_referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/expired_referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/pending_referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class ReferralListModule extends Module {
  PendingReferralListBloc get pendingReferralListBloc => get();
  CompletedReferralListBloc get completedReferralListBloc => get();
  ExpiredReferralListBloc get expiredReferralListBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => PendingReferralListBloc(get()));
    provideSingleton(() => CompletedReferralListBloc(get()));
    provideSingleton(() => ExpiredReferralListBloc(get()));
  }
}

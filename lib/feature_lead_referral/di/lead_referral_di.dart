import 'package:lykke_mobile_mavn/feature_lead_referral/bloc/lead_referal_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LeadReferralModule extends Module {
  LeadReferralBloc get leadReferralBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => LeadReferralBloc(get(), get()));
  }
}

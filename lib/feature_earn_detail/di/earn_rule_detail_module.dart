import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_availability_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_referral_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class EarnRuleDetailModule extends Module {
  EarnRuleDetailBloc get earnRuleDetailBloc => get();

  EarnRuleAvailabilityBloc get earnRuleAvailabilityBloc => get();

  EarnRuleReferralsBloc get earnRuleReferralsBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => EarnRuleDetailBloc(get()));
    provideSingleton(() => EarnRuleAvailabilityBloc());
    provideSingleton(() => EarnRuleReferralsBloc(get()));
  }
}

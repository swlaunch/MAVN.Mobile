import 'package:lykke_mobile_mavn/feature_home/bloc/staking_referrals_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class StakingReferralsModule extends Module {
  StakingReferralsBloc get stakingReferralsBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => StakingReferralsBloc(get()));
  }
}

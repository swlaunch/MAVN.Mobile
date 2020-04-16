import 'package:lykke_mobile_mavn/feature_app_referral/bloc/friend_referral_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class FriendReferralModule extends Module {
  FriendReferralBloc get friendReferralBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => FriendReferralBloc(get(), get()));
  }
}

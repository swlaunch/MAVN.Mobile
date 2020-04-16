import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class HotelReferralModule extends Module {
  HotelReferralBloc get hotelReferralBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => HotelReferralBloc(get(), get()));
  }
}

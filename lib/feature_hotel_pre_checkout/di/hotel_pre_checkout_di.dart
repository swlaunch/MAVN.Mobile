import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/bloc/hotel_pre_checkout_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class HotelPreCheckoutModule extends Module {
  HotelPreCheckoutBloc get hotelPreCheckoutBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => HotelPreCheckoutBloc(get(), get()));
  }
}

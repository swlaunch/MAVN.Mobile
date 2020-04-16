import 'package:lykke_mobile_mavn/feature_hotel_welcome/bloc/hotel_welcome_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class HotelWelcomeModule extends Module {
  HotelWelcomeBloc get hotelWelcomeBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => HotelWelcomeBloc(get(), get()));
  }
}

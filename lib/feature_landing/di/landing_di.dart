import 'package:lykke_mobile_mavn/feature_landing/bloc/route_authentication_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LandingModule extends Module {
  RouteAuthenticationBloc get routeAuthenticationBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => RouteAuthenticationBloc(get()));
  }
}

import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class RouteAuthenticationState extends BlocState {}

class RouteAuthenticationEvent extends BlocEvent {}

class RouteAuthenticationUninitializedState extends RouteAuthenticationState {}

class RouteAuthenticationLoadingState extends RouteAuthenticationState {}

class RouteAuthenticationLoadedState extends RouteAuthenticationState {}

class RouteAuthenticationLoadedEvent extends RouteAuthenticationEvent {
  RouteAuthenticationLoadedEvent(this.target);

  final RouteAuthenticationTarget target;
}

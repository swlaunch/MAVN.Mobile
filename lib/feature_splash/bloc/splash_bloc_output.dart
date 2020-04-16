import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class SplashState extends BlocState {}

abstract class SplashEvent extends BlocEvent {}

abstract class SplashBaseErrorState extends SplashState {}

class SplashUninitializedState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashSuccessState extends SplashState {}

class SplashRedirectToTargetPageEvent extends SplashEvent {
  SplashRedirectToTargetPageEvent(this.target);

  final RouteAuthenticationTarget target;

  @override
  List get props => [target];
}

class SplashErrorState extends SplashBaseErrorState {}

class SplashNetworkErrorState extends SplashBaseErrorState {}

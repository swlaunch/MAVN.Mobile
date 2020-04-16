import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/feature_landing/bloc/route_authentication_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/feature_landing/di/landing_di.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class RouteAuthenticationBloc extends Bloc<RouteAuthenticationState> {
  RouteAuthenticationBloc(this._useCase);

  final RouteAuthenticationUseCase _useCase;

  @override
  RouteAuthenticationState initialState() =>
      RouteAuthenticationUninitializedState();

  Future<void> routeTo({RouteAuthenticationPage targetPage}) async {
    setState(RouteAuthenticationLoadingState());

    final flowTarget = await _useCase.execute(endPage: targetPage);

    setState(RouteAuthenticationLoadedState());
    sendEvent(RouteAuthenticationLoadedEvent(flowTarget));
  }
}

RouteAuthenticationBloc useRouteAuthenticationBloc() =>
    ModuleProvider.of<LandingModule>(useContext()).routeAuthenticationBloc;

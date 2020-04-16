import 'package:lykke_mobile_mavn/feature_register/analytics/register_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_register/bloc/register_bloc.dart';
import 'package:lykke_mobile_mavn/feature_register/use_case/register_use_case.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class RegisterModule extends Module {
  RegisterBloc get registerBloc => get();

  RegisterAnalyticsManager get registerAnalyticsManager => get();

  @override
  void provideInstances() {
    provideSingleton(() => RegisterAnalyticsManager(get()));
    provideSingleton(() => RegisterUseCase(get(), get(), get(), get()));
    provideSingleton(() => RegisterBloc(get(), get()));
  }
}
